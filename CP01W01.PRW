#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "APWEBSRV.CH"

#DEFINE EOL			Chr(13)+Chr(10)  


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CP01W01  ºAutor  ³ Augusto Ribeiro	 º Data ³  31/12/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Web Service para Validação da DANFE                        º±±
±±º          ³ Deve ser compila do TSS                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
//| Debug de WS, funcao:  WSDLDbgLevel(2)
WSSERVICE ValidaDanfeSefaz DESCRIPTION "Valida DANFE junto ao Sefaz <br> Somente Ambiente de Produção - v2.0 <br>www.compila.com.br"

	WsData ChaveLinceca			As String
	WsData ChaveDANFE			As String            
	WsData UFDanfe				As String 
	WsData NFECTE				As String 	
	
	WsData RetornoXML			As String
	
	//-- Metodos --\\ 
	WSMETHOD ValidaDanfe		DESCRIPTION "Valida DANFE junto ao Sefaz"
	
ENDWSSERVICE
          
          
WSMETHOD ValidaDanfe WSRECEIVE ChaveLinceca, ChaveDANFE, UFDanfe, NFECTE WSSEND RetornoXML WSSERVICE ValidaDanfeSefaz
Local lRet := .T.
Local oWS                
Local cXmlCabMsg	:= ""                              
Local nAmbiente, nModalidade
Local cModelo		:=""
Local cRegDPEC 		:= "" 
Local oXmlResult	
Local cXMlRetErro

Default ::ChaveDANFE	:= ""

Private cXMLRet	:= ""
Private cAviso	:= ""
Private cErro	:= ""  

CONOUT("###| ValidaDanfeSefaz - ValidaDanfe")

IF !EMPTY(::ChaveDANFE) .AND. !EMPTY(::UFDanfe)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se é NF-e ou CT-e ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF ::NFECTE == "NFE"  
		cModelo := "55"
	ELSEIF  ::NFECTE == "CTE"             
		cModelo := "57"	
	ENDIF


	::ChaveDANFE	:= alltrim(::ChaveDANFE)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ambiente         ³
	//³ 1 = Producao     ³
	//³ 2 = Homologacao  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nAmbiente   := 1     

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Modalidade            ³
	//³ 1 = Normal            ³
	//³ 3 = Contingencia SCAN ³
	//³ 4 = Ambiente Nacional ³
	//³ 6 = Sefaz Virtual     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//nModalidade := 1		
	aModalidade	:= {1,3,4,6}
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa Ambiente do TSS - SPED ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	InitSped()
	InitNfeSped()
	                 
	FOR nI := 1 TO Len(aModalidade)
		nModalidade	:=  aModalidade[nI] 
		/*
		conout("###| WS ValidaDanfeSefaz ANTES NfeConsNfe")
		conout("###| WS ValidaDanfeSefaz nAmbiente "+STR(nAmbiente))
		conout("###| WS ValidaDanfeSefaz nModalidade "+STR(nModalidade))
		conout("###| WS ValidaDanfeSefaz ChaveDANFE "+::ChaveDANFE)
		conout("###| WS ValidaDanfeSefaz cXMLRet "+cXMLRet)
		conout("###| WS ValidaDanfeSefaz cModelo "+cModelo)
		conout("###| WS ValidaDanfeSefaz UFDanfe "+::UFDanfe)
		conout("###| WS ValidaDanfeSefaz cRegDPEC "+cRegDPEC)
        */
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Consulta junto ao SEFAZ a validade da DANFE ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ     
		NfeConsNfe(nAmbiente,nModalidade,::ChaveDANFE,"","","",@cXMLRet,cModelo,::UFDanfe,cRegDPEC)      
		//|            1           2            3          4         5        6    7     
//		NfeConsNfe(nAmbiente,nModalidade,::ChaveDANFE,cProtocolo,cCodSta,cMsgSta,cXML,cNFMod,cUF,cRegDPEC,cXMLERP)
		::RetornoXML := cXMLRet  
		    /*
		conout("###| WS ValidaDanfeSefaz DEPOIS NfeConsNfe")
		conout("###| WS ValidaDanfeSefaz nAmbiente "+STR(nAmbiente))
		conout("###| WS ValidaDanfeSefaz nModalidade "+STR(nModalidade))
		conout("###| WS ValidaDanfeSefaz ChaveDANFE "+::ChaveDANFE)
		conout("###| WS ValidaDanfeSefaz cXMLRet "+cXMLRet)
		conout("###| WS ValidaDanfeSefaz cModelo "+cModelo)
		conout("###| WS ValidaDanfeSefaz UFDanfe "+::UFDanfe)
		conout("###| WS ValidaDanfeSefaz cRegDPEC "+cRegDPEC)		
		      */
		IF !EMPTY(cXMLRet) 
			cAviso	:= ""                                        
			cErro	:= ""
			oXmlResult	:= XmlParser(EncodeUTF8(cXMLRet),"_",@cAviso,@cErro)   
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Valida estrutura de retorno ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	  
			lXmlRet	:= .F.       
			IF VALTYPE(oXmlResult) == "O"
				IF VALTYPE(XmlChildEx(oXmlResult, "_RETCONSSITNFE")) == "O"     
					IF VALTYPE(XmlChildEx(oXmlResult:_RETCONSSITNFE, "_INFPROT")) == "O"     		
						oXmlResult	:= oXmlResult:_RETCONSSITNFE:_INFPROT
					ELSE
						oXmlResult	:= oXmlResult:_RETCONSSITNFE
					ENDIF
					
					IF VALTYPE(XmlChildEx(oXmlResult, "_XMOTIVO")) == "O"			
						IF VALTYPE(XmlChildEx(oXmlResult, "_CSTAT")) == "O"
							lXmlRet	:= .T.             
						ELSE
							cXMlRetErro	:= "Node nao localizado: _CSTAT"
					    ENDIF                           
					ELSE
						cXMlRetErro	:= "Node nao localizado: _XMOTIVO"
					ENDIF
				ELSE
					cXMlRetErro	:= "Node nao localizado: _RETCONSSITNFE"
				ENDIF 
			ELSE     
				cXMlRetErro	:= " cAviso: "+ALLTRIM(cAviso)+"cErro: "+ALLTRIM(cErro)
				conout("###| WS ValidaDanfeSefaz "+cXMlRetErro)		
			ENDIF	
		          
		
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Estrutura do XML retornado pelo Sefaz OK ? ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF lXmlRet
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Nota Fiscal Valida ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cCodRetNFe	:= ALLTRIM(oXmlResult:_cStat:Text)
				IF cCodRetNFe == "217" //| NF-e nao consta na base do sefaz
					conout("###| WS ValidaDanfeSefaz Mod("+alltrim(str(aModalidade[nI]))+")- 217: NF-e nao consta na base do sefaz ")
					LOOP
				ENDIF
			ENDIF       
			
			EXIT 
		ELSE             
			cXMlRetErro	:= "Retorno NfeConsNfe em branco"
			conout("###| WS ValidaDanfeSefaz"+cXMlRetErro)
		ENDIF
	NEXT nI
	
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza ambiente do TSS - SPED ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FinishNfeSped()
	FinishSped(.T.)    
ENDIF

Return lRet
