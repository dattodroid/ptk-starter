#include <stdio.h>
#include <wchar.h>
/*-------------------------- Pro/Toolkit includes ---------------------------*/
#include <ProToolkit.h>
#include <ProMenu.h>
#include <ProMenuBar.h>
#include <ProUIMessage.h>
#include <ProArray.h>

/*-------------------------- Application defines ----------------------------*/

wchar_t *msgfil = L"message.txt";
FILE *logFile = NULL;

#define LOG(...) \
	fprintf(logFile, __VA_ARGS__)

#define LOG_MSG(msg) \
	fprintf(logFile, "%s\n", msg)

#define LOG_RC(api, rc) \
	fprintf(logFile, "[%s] %s -> (%d) \n", __func__, #api, (int)(rc))

int button_callback(ProAppData arg_1, int arg_2);

int user_initialize()
{
	ProError perr = PRO_TK_NO_ERROR;
	uiCmdCmdId cmd_id;

	logFile = fopen("debug.log", "a+");
	LOG_MSG("Pro/TK user_initialize()");

	perr = ProCmdActionAdd("TKButton",
						   (uiCmdCmdActFn)button_callback,
						   uiProeImmediate, NULL, PRO_B_TRUE,
						   PRO_B_TRUE, &cmd_id);

	perr = ProCmdDesignate(cmd_id, "Toolkit Button", "Toolkit Button", "Toolkit Button", msgfil);

	perr = ProMenubarMenuAdd(
		"Toolkit Menu", "Toolkit Menu", "Help",
		PRO_B_TRUE, msgfil);

	perr = ProMenubarmenuPushbuttonAdd(
		"Toolkit Menu", "Toolkit Button",
		"Toolkit Button", "Toolkit Button",
		NULL, PRO_B_TRUE, cmd_id,
		msgfil);

	return (0);
}

int button_callback(ProAppData arg_1, int arg_2)
{
	ProError perr = PRO_TK_NO_ERROR;
	ProUIMessageButton *buttons;
	ProUIMessageButton user_choice;

	perr = ProArrayAlloc(1, sizeof(ProUIMessageButton),
						 1, (ProArray *)&buttons);

	buttons[0] = PRO_UI_MESSAGE_OK;

	perr = ProUIMessageDialogDisplay(PROUIMESSAGE_INFO,
									 L"Info",
									 L"Hello from Pro/Toolkit.",
									 buttons,
									 PRO_UI_MESSAGE_OK,
									 &user_choice);
	LOG_RC(ProUIMessageDialogDisplay, perr);

	ProArrayFree((ProArray *)&buttons);

	fflush(logFile);
	return (0);
}

void user_terminate()
{
	LOG_MSG("Pro/TK user_terminate()");
	fclose(logFile);
}