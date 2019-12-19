﻿#include "stdafx.h"

#include <minwindef.h>
#include <wtypes.h>
#include "AddInNative.h"
#include "convertor.h"
#include <memory>
#include <locale>

#include "WinCtrl.h"
#include "ProcMngr.h"

const CAddInNative::Alias CAddInNative::m_PropNames[] = {
	Alias(eCurrentWindow , L"CurrentWindow"   , L"ТекущееОкно"),
	Alias(eActiveWindow  , L"ActiveWindow"    , L"АктивноеОкно"),
	Alias(eProcessId     , L"ProcessId"       , L"ИдентификаторПроцесса"),
};

const CAddInNative::Alias CAddInNative::m_MethNames[] = {
	Alias(eFindTestClient , L"FindTestClient" , L"НайтиКлиентТестирования"),
	Alias(eGetProcessList , L"GetProcessList" , L"ПолучитьСписокПроцессов"),
	Alias(eGetProcessInfo , L"GetProcessInfo" , L"ПолучитьДанныеПроцесса"),
	Alias(eFindProcess    , L"FindProcess"    , L"НайтиПроцесс"),
	Alias(eGetWindowList  , L"GetWindowList"  , L"ПолучитьСписокОкон"),
	Alias(eSetWindowSize  , L"SetWindowSize"  , L"УстановитьРазмерОкна"),
	Alias(eSetWindowPos   , L"SetWindowPos"   , L"УстановитьПозициюОкна"),
	Alias(eEnableResizing , L"EnableResizing" , L"РазрешитьИзменятьРазмер"),
	Alias(eTakeScreenshot , L"TakeScreenshot" , L"ПолучитьСнимокЭкрана"),
	Alias(eCaptureWindow  , L"CaptureWindow"  , L"ПолучитьСнимокОкна"),
	Alias(eGetWindowText  , L"GetWindowText"  , L"ПолучитьЗаголовок"),
	Alias(eSetWindowText  , L"SetWindowText"  , L"УстановитьЗаголовок"),
	Alias(eActivateWindow , L"ActivateWindow" , L"АктивироватьОкно"),
	Alias(eMaximizeWindow , L"MaximizeWindow" , L"РаспахнутьОкно"),
	Alias(eRestoreWindow  , L"RestoreWindow"  , L"РазвернутьОкно"),
	Alias(eMinimizeWindow , L"MinimizeWindow" , L"СвернутьОкно"),
};

int const CAddInNative::m_PropCount = sizeof(CAddInNative::m_PropNames) / sizeof(CAddInNative::Alias);

int const CAddInNative::m_MethCount = sizeof(CAddInNative::m_MethNames) / sizeof(CAddInNative::Alias);

static std::wstring param(tVariant* paParams, const long lSizeArray)
{
	std::wstring result;
	switch (TV_VT(paParams)) {
	case VTYPE_PWSTR: {
		wchar_t* str = 0;
		::convFromShortWchar(&str, TV_WSTR(paParams));
		result = str;
		delete[] str;
	} break;
	default:
		break;
	}
	return result;
}

/////////////////////////////////////////////////////////////////////////////
// CAddInNative
//---------------------------------------------------------------------------//
CAddInNative::CAddInNative()
{
	m_iMemory = 0;
	m_iConnect = 0;
}
//---------------------------------------------------------------------------//
CAddInNative::~CAddInNative()
{
}
//---------------------------------------------------------------------------//
bool CAddInNative::Init(void* pConnection)
{
	m_iConnect = (IAddInDefBase*)pConnection;
	return m_iConnect != NULL;
}
//---------------------------------------------------------------------------//
long CAddInNative::GetInfo()
{
	// Component should put supported component technology version 
	// This component supports 2.0 version
	return 2000;
}
//---------------------------------------------------------------------------//
void CAddInNative::Done()
{
}
/////////////////////////////////////////////////////////////////////////////
// ILanguageExtenderBase
//---------------------------------------------------------------------------//
bool CAddInNative::RegisterExtensionAs(WCHAR_T** wsExtensionName)
{
	return W(L"WindowsControl", wsExtensionName);
}
//---------------------------------------------------------------------------//
long CAddInNative::GetNProps()
{
	return ePropLast;
}

//---------------------------------------------------------------------------//
long CAddInNative::FindName(const CAddInNative::Alias names[], long size, const WCHAR_T* name)
{
	for (long i = 0; i < size; i++) {
		for (long j = 0; j < ALIAS_COUNT; j++) {
			if (wcsicmp(names[i].Name(j), name) == 0) return i;
		}
	}
	return -1;
}

//---------------------------------------------------------------------------//
const WCHAR_T* CAddInNative::GetName(const CAddInNative::Alias names[], long size, long lPropNum, long lPropAlias)
{
	if (lPropNum >= size) return NULL;
	if (lPropAlias >= ALIAS_COUNT) return NULL;
	for (long i = 0; i < size; i++) {
		if (names[i].id == lPropNum) {
			return W((wchar_t*)names[i].Name(lPropAlias));
		}
	}
	return NULL;
}

//---------------------------------------------------------------------------//
const WCHAR_T* CAddInNative::W(const wchar_t* str) const
{
	WCHAR_T* res = NULL;
	W(str, &res);
	return res;
}

//---------------------------------------------------------------------------//
BOOL CAddInNative::W(const wchar_t* str, WCHAR_T** res) const
{
	if (m_iMemory && str) {
		size_t size = wcslen(str) + 1;
		if (m_iMemory->AllocMemory((void**)res, size * sizeof(WCHAR_T))) {
			::convToShortWchar(res, str, size);
			return true;
		}
	}
	return false;
}

//---------------------------------------------------------------------------//
BOOL CAddInNative::W(const wchar_t* str, tVariant* res) const
{
	TV_VT(res) = VTYPE_PWSTR;
	res->pwstrVal = NULL;
	res->wstrLen = 0;
	if (m_iMemory && str) {
		size_t size = wcslen(str) + 1;
		if (m_iMemory->AllocMemory((void**)&res->pwstrVal, size * sizeof(WCHAR_T))) {
			::convToShortWchar((WCHAR_T**)&res->pwstrVal, str, size);
			res->wstrLen = size;
			return true;
		}
	}
	return false;
}

//---------------------------------------------------------------------------//
BOOL CAddInNative::W(const DWORD& val, tVariant* res) const
{
	TV_VT(res) = VTYPE_UI4;
	res->uintVal = (uint32_t)val;
	return true;
}

//---------------------------------------------------------------------------//
long CAddInNative::FindProp(const WCHAR_T* wsPropName)
{
	return FindName(m_PropNames, ePropLast, wsPropName);
}

//---------------------------------------------------------------------------//
const WCHAR_T* CAddInNative::GetPropName(long lPropNum, long lPropAlias)
{
	return GetName(m_PropNames, ePropLast, lPropNum, lPropAlias);
}

//---------------------------------------------------------------------------//
bool CAddInNative::GetPropVal(const long lPropNum, tVariant* pvarPropVal)
{
	switch (lPropNum) {
	case eCurrentWindow:
		return W((DWORD)WindowsControl::CurrentWindow(), pvarPropVal);
	case eActiveWindow:
		return W((DWORD)WindowsControl::ActiveWindow(), pvarPropVal);
	case eProcessId:
		return W(ProcessManager::ProcessId(), pvarPropVal);
	default:
		return false;
	}
}
//---------------------------------------------------------------------------//
bool CAddInNative::SetPropVal(const long lPropNum, tVariant* varPropVal)
{
	return false;
}
//---------------------------------------------------------------------------//
bool CAddInNative::IsPropReadable(const long lPropNum)
{
	return true;
}
//---------------------------------------------------------------------------//
bool CAddInNative::IsPropWritable(const long lPropNum)
{
	return false;
}
//---------------------------------------------------------------------------//
long CAddInNative::GetNMethods()
{
	return eMethLast;
}
//---------------------------------------------------------------------------//
long CAddInNative::FindMethod(const WCHAR_T* wsMethodName)
{
	return FindName(m_MethNames, eMethLast, wsMethodName);
}
//---------------------------------------------------------------------------//
const WCHAR_T* CAddInNative::GetMethodName(const long lMethodNum, const long lMethodAlias)
{
	return GetName(m_MethNames, eMethLast, lMethodNum, lMethodAlias);
}
//---------------------------------------------------------------------------//
long CAddInNative::GetNParams(const long lMethodNum)
{
	switch (lMethodNum)
	{
	case eFindTestClient:
		return 2;
	case eGetProcessList:
		return 1;
	case eGetProcessInfo:
		return 1;
	case eSetWindowSize:
		return 3;
	case eSetWindowPos:
		return 3;
	case eEnableResizing:
		return 2;
	case eTakeScreenshot:
		return 1;
	case eCaptureWindow:
		return 1;
	case eGetWindowText:
		return 1;
	case eSetWindowText:
		return 2;
	case eMaximizeWindow:
		return 1;
	case eRestoreWindow:
		return 1;
	case eMinimizeWindow:
		return 1;
	case eActivateWindow:
		return 1;
	default:
		return 0;
	}
}
//---------------------------------------------------------------------------//
bool CAddInNative::GetParamDefValue(const long lMethodNum, const long lParamNum, tVariant* pvarParamDefValue)
{
	TV_VT(pvarParamDefValue) = VTYPE_EMPTY;
	return false;
}
//---------------------------------------------------------------------------//
bool CAddInNative::HasRetVal(const long lMethodNum)
{
	switch (lMethodNum)
	{
	case eFindTestClient:
	case eGetProcessList:
	case eGetProcessInfo:
	case eGetWindowList:
	case eSetWindowSize:
	case eSetWindowPos:
	case eTakeScreenshot:
	case eCaptureWindow:
	case eGetWindowText:
		return true;
	default:
		return false;
	}
}
//---------------------------------------------------------------------------//
bool CAddInNative::CallAsProc(const long lMethodNum, tVariant* paParams, const long lSizeArray)
{
	switch (lMethodNum)
	{
	case eSetWindowSize:
		return WindowsControl::SetWindowSize(paParams, lSizeArray);
	case eSetWindowPos:
		return WindowsControl::SetWindowPos(paParams, lSizeArray);
	case eEnableResizing:
		return WindowsControl::EnableResizing(paParams, lSizeArray);
	case eSetWindowText:
		return WindowsControl::SetText(paParams, lSizeArray);
	case eMaximizeWindow:
		return WindowsControl::Maximize(paParams, lSizeArray);
	case eMinimizeWindow:
		return WindowsControl::Minimize(paParams, lSizeArray);
	case eRestoreWindow:
		return WindowsControl::Restore(paParams, lSizeArray);
	case eActivateWindow:
		return WindowsControl::Activate(paParams, lSizeArray);
	default:
		return false;
	}
}

//---------------------------------------------------------------------------//
bool CAddInNative::CallAsFunc(const long lMethodNum, tVariant* pvarRetValue, tVariant* paParams, const long lSizeArray)
{
	switch (lMethodNum) {
	case eGetWindowList:
		return W(WindowsControl::GetWindowList(), pvarRetValue);
	case eFindTestClient: {
		std::wstring result;
		bool ok = W((DWORD)ProcessManager::FindTestClient(paParams, lSizeArray, result), pvarRetValue);
		if (ok && lSizeArray > 1) W(result, paParams + 1);
		return ok;
	}
	case eGetProcessList:
		return W(ProcessManager::GetProcessList(paParams, lSizeArray), pvarRetValue);
	case eGetProcessInfo:
		return W(ProcessManager::GetProcessInfo(paParams, lSizeArray), pvarRetValue);
	case eSetWindowSize:
		return W(WindowsControl::SetWindowSize(paParams, lSizeArray), pvarRetValue);
	case eSetWindowPos:
		return W(WindowsControl::SetWindowPos(paParams, lSizeArray), pvarRetValue);
	case eEnableResizing:
		return W(WindowsControl::EnableResizing(paParams, lSizeArray), pvarRetValue);
	case eTakeScreenshot:
		return WindowsControl(m_iMemory).CaptureScreen(pvarRetValue, paParams, lSizeArray);
	case eCaptureWindow:
		return WindowsControl(m_iMemory).CaptureWindow(pvarRetValue, paParams, lSizeArray);
	case eGetWindowText:
		return W(WindowsControl::GetText(paParams, lSizeArray), pvarRetValue);
	case eSetWindowText:
		return WindowsControl::SetText(paParams, lSizeArray);
	case eMaximizeWindow:
		return WindowsControl::Maximize(paParams, lSizeArray);
	case eActivateWindow:
		return WindowsControl::Activate(paParams, lSizeArray);
	default:
		return false;
	}
}
//---------------------------------------------------------------------------//
void CAddInNative::SetLocale(const WCHAR_T* loc)
{
#if !defined( __linux__ ) && !defined(__APPLE__)
	_wsetlocale(LC_ALL, loc);
#else
	//We convert in char* char_locale
	//also we establish locale
	//setlocale(LC_ALL, char_locale);
#endif
}
/////////////////////////////////////////////////////////////////////////////
// LocaleBase
//---------------------------------------------------------------------------//
bool CAddInNative::setMemManager(void* mem)
{
	m_iMemory = (IMemoryManager*)mem;
	return m_iMemory != 0;
}
//---------------------------------------------------------------------------//
void CAddInNative::addError(uint32_t wcode, const wchar_t* source, const wchar_t* descriptor, long code)
{
	if (m_iConnect)
	{
		WCHAR_T* err = 0;
		WCHAR_T* descr = 0;

		::convToShortWchar(&err, source);
		::convToShortWchar(&descr, descriptor);

		m_iConnect->AddError(wcode, err, descr, code);
		delete[] err;
		delete[] descr;
	}
}
//---------------------------------------------------------------------------//

