#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://192.168.1.3:81/sped/VALIDADANFESEFAZ.apw?WSDL
Gerado em        08/27/12 16:12:24
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.111215
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _PWSHZKB ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSVALIDADANFESEFAZ
------------------------------------------------------------------------------- */

WSCLIENT WSVALIDADANFESEFAZ

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD VALIDADANFE

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cCHAVELINCECA             AS string
	WSDATA   cCHAVEDANFE               AS string
	WSDATA   cUFDANFE                  AS string
	WSDATA   cNFECTE                   AS string
	WSDATA   cVALIDADANFERESULT        AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSVALIDADANFESEFAZ
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.111010P-20120120] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSVALIDADANFESEFAZ
Return

WSMETHOD RESET WSCLIENT WSVALIDADANFESEFAZ
	::cCHAVELINCECA      := NIL 
	::cCHAVEDANFE        := NIL 
	::cUFDANFE           := NIL 
	::cNFECTE            := NIL 
	::cVALIDADANFERESULT := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSVALIDADANFESEFAZ
Local oClone := WSVALIDADANFESEFAZ():New()
	oClone:_URL          := ::_URL 
	oClone:cCHAVELINCECA := ::cCHAVELINCECA
	oClone:cCHAVEDANFE   := ::cCHAVEDANFE
	oClone:cUFDANFE      := ::cUFDANFE
	oClone:cNFECTE       := ::cNFECTE
	oClone:cVALIDADANFERESULT := ::cVALIDADANFERESULT
Return oClone

// WSDL Method VALIDADANFE of Service WSVALIDADANFESEFAZ

WSMETHOD VALIDADANFE WSSEND cCHAVELINCECA,cCHAVEDANFE,cUFDANFE,cNFECTE WSRECEIVE cVALIDADANFERESULT WSCLIENT WSVALIDADANFESEFAZ
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<VALIDADANFE xmlns="http://192.168.1.3:81/">'
cSoap += WSSoapValue("CHAVELINCECA", ::cCHAVELINCECA, cCHAVELINCECA , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("CHAVEDANFE", ::cCHAVEDANFE, cCHAVEDANFE , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("UFDANFE", ::cUFDANFE, cUFDANFE , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("NFECTE", ::cNFECTE, cNFECTE , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</VALIDADANFE>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://192.168.1.3:81/VALIDADANFE",; 
	"DOCUMENT","http://192.168.1.3:81/",,"1.031217",; 
	"http://192.168.1.3:81/sped/VALIDADANFESEFAZ.apw")

::Init()
::cVALIDADANFERESULT :=  WSAdvValue( oXmlRet,"_VALIDADANFERESPONSE:_VALIDADANFERESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.



