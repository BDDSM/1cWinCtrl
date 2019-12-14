#ifndef __WINCTRL_H__
#define __WINCTRL_H__

#include <types.h>
#include <string>
#include "IMemoryManager.h"

class SetWindow {
public:
	static std::wstring GetWindowList();
	static std::wstring GetWindowText(tVariant* paParams, const long lSizeArray);
	static BOOL SetWindowSize(tVariant* paParams, const long lSizeArray);
	static BOOL SetWindowPos(tVariant* paParams, const long lSizeArray);
	static BOOL ActivateWindow(tVariant* paParams, const long lSizeArray);
	static BOOL EnableResizing(tVariant* paParams, const long lSizeArray);
	static HWND ActiveWindow();
	static HWND CurrentWindow();
	static DWORD ProcessId();
public:
	SetWindow(IMemoryManager* iMemory) { m_iMemory = iMemory; }
	BOOL CaptureWindow(tVariant* pvarRetValue, tVariant* paParams, const long lSizeArray);
private:
	IMemoryManager* m_iMemory;
};

#endif //__WINCTRL_H__