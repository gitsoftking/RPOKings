#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "APWEBSRV.CH"

#DEFINE EOL			Chr(13)+Chr(10)  


/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CP01W01  �Autor  � Augusto Ribeiro	 � Data �  31/12/2010 ���
�������������������������������������������������������������������������͹��
���Desc.     � Web Service para Valida��o da DANFE                        ���
���          � Deve ser compila do TSS                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
//| Debug de WS, funcao:  WSDLDbgLevel(2)
WSSERVICE ValidaDanfeSefaz DESCRIPTION "Valida DANFE junto ao Sefaz <br> Somente Ambiente de Produ��o - v2.0 <br>www.compila.com.br"

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

	//������������������������������
	//� Verifica se � NF-e ou CT-e �
	//������������������������������
	IF ::NFECTE == "NFE"  
		cModelo := "55"
	ELSEIF  ::NFECTE == "CTE"             
		cModelo := "57"	
	ENDIF


	::ChaveDANFE	:= alltrim(::ChaveDANFE)
	
	//������������������Ŀ
	//� Ambiente         �
	//� 1 = Producao     �
	//� 2 = Homologacao  �
	//��������������������
	nAmbiente   := 1     

	//�����������������������Ŀ
	//� Modalidade            �
	//� 1 = Normal            �
	//� 3 = Contingencia SCAN �
	//� 4 = Ambiente Nacional �
	//� 6 = Sefaz Virtual     �
	//�������������������������
	//nModalidade := 1		
	aModalidade	:= {1,3,4,6}
	
	
	//�����������������������������������Ŀ
	//� Inicializa Ambiente do TSS - SPED �
	//�������������������������������������
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
		
		//���������������������������������������������Ŀ
		//� Consulta junto ao SEFAZ a validade da DANFE �
		//�����������������������������������������������     
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
		
			//�����������������������������Ŀ
			//� Valida estrutura de retorno �
			//�������������������������������	  
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
		          
		
		
			//��������������������������������������������Ŀ
			//� Estrutura do XML retornado pelo Sefaz OK ? �
			//����������������������������������������������
			IF lXmlRet
				//�������������������Ŀ
				//�Nota Fiscal Valida �
				//���������������������
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
	
	
	
	//���������������������������������Ŀ
	//� Finaliza ambiente do TSS - SPED �
	//�����������������������������������
	FinishNfeSped()
	FinishSped(.T.)    
ENDIF

Return lRet
