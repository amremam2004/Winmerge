/////////////////////////////////////////////////////////////////////////////
// DirScan.cpp : implementation file
//

#include "stdafx.h"
#include "DirScan.h"
#include "DiffContext.h"
#include "logfile.h"
#include "paths.h"

extern int just_compare_files (LPCTSTR, LPCTSTR, int);
extern CLogFile gLog;

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

// directory or file info
struct fentry
{
	CString name;
	long mtime;
	_int64 size;
};
typedef CArray<fentry, fentry&> fentryArray;;

static void LoadFiles(const CString & sDir, fentryArray * dirs, fentryArray * files);
void LoadAndSortFiles(const CString & sDir, fentryArray * dirs, fentryArray * files, bool casesensitive);
static void Sort(fentryArray * dirs, bool casesensitive);;
static int collstr(const CString & s1, const CString & s2, bool casesensitive);
static void FilterAdd(const CString & sDir, const fentry * lent, const fentry *rent, int code, CDiffContext * pCtxt);


typedef int (CString::*cmpmth)(LPCTSTR sz) const;
#define CALL_MEMBER_FN(object,ptrToMember)  ((object).*(ptrToMember))


int DirScan(const CString & subdir, CDiffContext * pCtxt, bool casesensitive, int depth)
{
	CString sLeftDir = pCtxt->m_strNormalizedLeft;
	CString sRightDir = pCtxt->m_strNormalizedRight;
	CString subprefix;
	if (!subdir.IsEmpty())
	{
		sLeftDir += _T("\\") + subdir;
		sRightDir += _T("\\") + subdir;
		subprefix = subdir + _T("\\");
	}
	cmpmth mthptr = (casesensitive ? &CString::Collate : &CString::CollateNoCase);
	fentryArray leftDirs, leftFiles, rightDirs, rightFiles;
	LoadAndSortFiles(sLeftDir, &leftDirs, &leftFiles, casesensitive);
	LoadAndSortFiles(sRightDir, &rightDirs, &rightFiles, casesensitive);

	int i=0, j=0;
	while (1)
	{
		if (i<leftDirs.GetSize())
			TRACE(_T("Candidate left: leftDirs[i]=%s\n"), leftDirs[i]);
		if (j<rightDirs.GetSize())
			TRACE(_T("Candidate right: rightDirs[j]=%s\n"), rightDirs[j]);
		while (i<leftDirs.GetSize() && (j==rightDirs.GetSize() || collstr(leftDirs[i].name, rightDirs[j].name, casesensitive)<0))
		{
			FilterAdd(subdir, &leftDirs[i], 0, FILE_LDIRUNIQUE, pCtxt);
			++i;
			continue;
		}
		while (j<rightDirs.GetSize() && (i==leftDirs.GetSize() || collstr(leftDirs[i].name, rightDirs[j].name, casesensitive)>0))
		{
			FilterAdd(subdir, 0, &rightDirs[j], FILE_RDIRUNIQUE, pCtxt);
			++j;
			continue;
		}
		if (i<leftDirs.GetSize())
		{
			ASSERT(j<rightDirs.GetSize());
			CString newsub = subprefix + leftDirs[i].name;
			if (!depth || !pCtxt->m_piFilter->includeDir(newsub))
			{
				FilterAdd(subdir, &leftDirs[i], &rightDirs[j], FILE_DIRSKIP, pCtxt);
			}
			else
			{
				DirScan(newsub, pCtxt, casesensitive, depth-1); 
			}
			++i;
			++j;
			continue;
		}
		break;
	}
	i=0, j=0;
	while (1)
	{
		if (i<leftFiles.GetSize())
			TRACE(_T("Candidate left: leftFiles[i]=%s\n"), leftFiles[i]);
		if (j<rightFiles.GetSize())
			TRACE(_T("Candidate right: rightFiles[j]=%s\n"), rightFiles[j]);
		if (i<leftFiles.GetSize() && (j==rightFiles.GetSize() || collstr(leftFiles[i].name, rightFiles[j].name, casesensitive)<0))
		{
			FilterAdd(subdir, &leftFiles[i], 0, FILE_LUNIQUE, pCtxt);
			++i;
			continue;
		}
		if (j<rightFiles.GetSize() && (i==leftFiles.GetSize() || collstr(leftFiles[i].name, rightFiles[j].name, casesensitive)>0))
		{
			FilterAdd(subdir, 0, &rightFiles[j], FILE_RUNIQUE, pCtxt);
			++j;
			continue;
		}
		if (i<leftFiles.GetSize())
		{
			ASSERT(j<rightFiles.GetSize());
			CString newsubfile = subprefix + leftFiles[i].name;
			if (!pCtxt->m_piFilter->includeFile(newsubfile))
			{
				FilterAdd(subdir, &leftFiles[i], &rightFiles[j], FILE_SKIP, pCtxt);
			}
			else
			{
				gLog.Write(_T("Comparing: n0=%s, n1=%s, d0=%s, d1=%s")
					, leftFiles[i].name, rightFiles[j].name, sLeftDir, sRightDir);
				CString filepath1 = paths_ConcatPath(sLeftDir, leftFiles[i].name);
				CString filepath2 = paths_ConcatPath(sRightDir, rightFiles[j].name);

				int res = just_compare_files (filepath1, filepath2, 0);
				// Outstanding problem 
				// Diff didn't tell us if the file is binary
				if (res == 0)
				{
					// same
					FilterAdd(subdir, &leftFiles[i], &rightFiles[j], FILE_SAME, pCtxt);
				}
				else if (res == 1)
				{
					// different
					FilterAdd(subdir, &leftFiles[i], &rightFiles[j], FILE_DIFF, pCtxt);
				}
				else 
				{
					if (res > 10)
					{
						// Program error
						// We passed something invalid to compare_files
						ASSERT(0);
					}
					// error
					FilterAdd(subdir, &leftFiles[i], &rightFiles[j], FILE_ERROR, pCtxt);
				}
			}
			++i;
			++j;
			continue;
		}
		break;
	}
	return 1;
}

static void TraceArray(const fentryArray * arr)
{
	return;
	TRACE(_T("Array has %d elements:\n"), arr->GetSize());
	for (int i=0; i<arr->GetSize(); ++i)
	{
		TRACE(_T("%d: %s\n"), i, (LPCTSTR)arr->GetAt(i).name);
	}
}

// Load arrays with all directories & files in specified dir
void LoadAndSortFiles(const CString & sDir, fentryArray * dirs, fentryArray * files, bool casesensitive)
{
	LoadFiles(sDir, dirs, files);
	TraceArray(dirs);
	TraceArray(files);
	Sort(dirs, casesensitive);
	Sort(files, casesensitive);
	TraceArray(dirs);
	TraceArray(files);
}

// Load arrays with all directories & files in specified dir
void LoadFiles(const CString & sDir, fentryArray * dirs, fentryArray * files)
{
	CString sPattern = sDir;
	if (!sPattern.IsEmpty() && sPattern[sPattern.GetLength()-1]!='\\')
		sPattern += '\\';
	sPattern += _T("\\*.*");
	CFileFind finder;
	BOOL bWorking = finder.FindFile(sPattern);
	while (bWorking)
	{
		bWorking = finder.FindNextFile();
		if (finder.IsDots())
			continue;
		fentry ent;
		CTime mtim;
		finder.GetLastWriteTime(mtim);
		ent.mtime = mtim.GetTime();
		ent.size = finder.GetLength64();
		ent.name = finder.GetFileName();
		if (finder.IsDirectory())
			dirs->Add(ent);
		else
			files->Add(ent);
	}
}

// case-sensitive collate function for qsorting an array
static int __cdecl cmpstring(const void *elem1, const void *elem2)
{
	const fentry * s1 = static_cast<const fentry *>(elem1);
	const fentry * s2 = static_cast<const fentry *>(elem2);
	return s1->name.Collate(s2->name);
}

// case-insensitive collate function for qsorting an array
static int __cdecl cmpistring(const void *elem1, const void *elem2)
{
	const fentry * s1 = static_cast<const fentry *>(elem1);
	const fentry * s2 = static_cast<const fentry *>(elem2);
	return s1->name.CollateNoCase(s2->name);
}

// sort specified array
void Sort(fentryArray * dirs, bool casesensitive)
{
	fentry * data = dirs->GetData();
	if (!data) return;
	int (__cdecl *comparefnc)(const void *elem1, const void *elem2) = (casesensitive ? cmpstring : cmpistring);
	qsort(data, dirs->GetSize(), sizeof(dirs->GetAt(0)), comparefnc);
}

// Compare (NLS aware) two strings, either case-sensitive or case-insensitive as caller specifies
static int collstr(const CString & s1, const CString & s2, bool casesensitive)
{
	if (casesensitive)
		return s1.Collate(s2);
	else
		return s1.CollateNoCase(s2);
}

// Add a result
static void FilterAdd(const CString & sDir, const fentry * lent, const fentry * rent, int code, CDiffContext * pCtxt)
{
//	TRACE(_T("subdir=%s, name=%s, code=%d\n"), (LPCTSTR)sDir, (LPCTSTR)ent.name, code);
	CString name, leftdir, rightdir;
	long rtime=0, ltime=0;
	_int64 lsize=0, rsize=0;
	if (lent)
	{
		leftdir = paths_ConcatPath(pCtxt->m_strNormalizedLeft, sDir);
		ltime = lent->mtime;
		lsize = lent->size;
		name = lent->name;
	}
	if (rent)
	{
		rightdir = paths_ConcatPath(pCtxt->m_strNormalizedRight, sDir);
		rtime = rent->mtime;
		rsize = rent->size;
		name = rent->name;
	}
	gLog.Write(_T("name=<%s>, leftdir=<%s>, rightdir=<%s>, code=%d")
		, (LPCTSTR)name, (LPCTSTR)leftdir, (LPCTSTR)rightdir, code);
	pCtxt->AddDiff(name, leftdir, rightdir, ltime, rtime, code);
}
