#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TBICONN.CH"
#include "MATA103.ch"

#DEFINE EOL			Chr(13)+Chr(10)  

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CP01GEN  ºAutor  ³ Augusto Ribeiro	 º Data ³  11/12/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcoes Genericas utilizada no Projeto Importacao XML Danfeº±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CP01G01  ºAutor  ³ Augusto Ribeiro	 º Data ³  11/12/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera Objeto de acordo com o XML passdo. Semelhante a funcaoº±±
±±º          ³ XmlParser                                                  º±±
±±º 	     ³                                                            º±±
±±ºParametros³ cXml: Indica uma string que contém o código XML.	          º±±
±±º 	     ³ cReplace: Indica o valor que será atribuído como prefixo   º±±
±±º 	     ³  para a nomenclatura das propriedades do objeto XML em Advplº±±
±±º 	     ³  a partir dos nomes dos nodes do documento XML. Será usandoº±±
±±º 	     ³  também na substituição de qualquer caractere usado no nomeº±±
±±º 	     ³  do node XML que não faça parte da nomenclatura de uma     º±±
±±º 	     ³  variável Adppl, como espaços em branco por exemplo.       º±±
±±º 	     ³ @cError: Retorna Erro                                      º±±
±±º 	     ³ @cWarning: Retorna Avisos                                  º±±
±±º 	     ³                                                            º±±
±±ºRetorno   ³ oRet: Objeto contendo as informacoes dos XML               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/     

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CP01G01  ºAutor  ³ Augusto Ribeiro	 º Data ³  11/12/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida DANFE junta ao Sefaz                                º±±
±±º          ³                                                            º±±
±±ºParametros³ cUF - Estada emitente da DANFE                             º±±
±±º          ³ cChvDanfe - Chave da DANFE                                 º±±
±±º          ³                                                            º±±
±±ºRetorno   ³aRet[nStatNFE, cMsg, cXMLRet]                               º±±
±±º          ³ nStatNFE: 1=Valida, 2=Invalida, 3=Consulta nao Disponivel, 4=Cancelada  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/     
User Function CP01G01(cUF, cChvDanfe,cTNfeCte ) 
Local aRet			:= {}
Local oWs, oXmlResult, lXmlRet
Local cCodRetNFe	:= "" 
Local aCodCan		:= {}
Local aCodInvalid	:= {}                  
                     
Local nStatNFE		:= 3
Local cMsg			:= ""
Local cXMLRet		:= "" 
Local cModelo		:= ""
Local cRegDPEC		:= ""

Private cAviso 		:= ""
Private cErro 		:= ""     




IF !EMPTY(cUF) .AND. !EMPTY(cChvDanfe)


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Codigo de Cancelamento ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aadd(aCodCan, "101")	//| 101 - Cancelamento de NF-e homologado
	aadd(aCodCan, "102")	//| 102 - Inutilização de número homologado
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Codigos de retorno do WS que indicam que a DANFE esteja invalida ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aadd(aCodInvalid, "110")	//| 110 - Uso Denegado
	aadd(aCodInvalid, "301")	//|	301 - Uso Denegado : Irregularidade fiscal do emitente
//	aadd(aCodInvalid, "302")	//| 302 - Uso Denegado : Irregularidade fiscal do destinatário 

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
	nModalidade := 1		

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa Ambiente do TSS - SPED ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//	InitSped()
//	InitNfeSped()    	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consulta junto ao SEFAZ a validade da DANFE ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//	NfeConsNfe(nAmbiente,1,cChvDanfe,"","","",@cXMLRet,cModelo,cUF,cRegDPEC) 
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza ambiente do TSS - SPED ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//	FinishNfeSped()
//	FinishSped(.T.)

	IF cTNfeCte == "C"
		cTNfeCte := "CTE"
	ELSE
		cTNfeCte := "NFE"	    
	ENDIF	


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa o servico de status                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	oWs := WSValidaDanfeSefaz():New()
	
	oWs:cCHAVELINCECA	:= ""
	oWs:cCHAVEDANFE		:= cChvDanfe
	oWs:cUFDANFE		:= cUF
	oWs:cNFECTE			:= cTNfeCte
	
	If oWs:ValidaDanfe()
		
		cXMLRet		:= oWs:cVALIDADANFERESULT
    	  
	
		IF !EMPTY(cXMLRet)
			cAviso		:= ""
			cErro		:= ""				
			oXmlResult	:= XmlParser(EncodeUTF8(cXMLRet),"_",@cAviso,@cErro)   
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Valida estrutura de retorno ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	  
			lXmlRet	:= .F.
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
			ELSEIF VALTYPE(XmlChildEx(oXmlResult, "_RETCONSSITCTE")) == "O" 
			
			
				
			
				IF  VALTYPE(XmlChildEx(oXmlResult:_RETCONSSITCTE,"_PROTCTE"))  == "O"
					
					IF VALTYPE(XmlChildEx(oXmlResult:_RETCONSSITCTE:_PROTCTE,"_INFPROT"))  == "O"     		
						oXmlResult	:= oXmlResult:_RETCONSSITCTE:_PROTCTE:_INFPROT
					ELSE
						oXmlResult	:= oXmlResult:_RETCONSSITCTE:_PROTCTE
					ENDIF
				ELSE	
					oXmlResult	:= oXmlResult:_RETCONSSITCTE
				ENDIF	


				IF VALTYPE(XmlChildEx(oXmlResult, "_XMOTIVO")) == "O"	
					cXMlRetErro	:= 	oXmlResult:_XMOTIVO:TEXT
					IF VALTYPE(XmlChildEx(oXmlResult, "_CSTAT")) == "O"
						lXmlRet	:= .T.             
					ELSE
						cXMlRetErro	+= " | Node nao localizado: _CSTAT"
				    ENDIF                           
				ELSE
					cXMlRetErro	:= "Node nao localizado: _XMOTIVO"
				ENDIF			

			ELSE
				cXMlRetErro	:= "Node nao localizado: _RETCONSSITNFE"
			ENDIF		
			      
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Estrutura do XML retornado pelo Sefaz OK ? ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF lXmlRet
	
				cMsg		:= alltrim(oXmlResult:_xMotivo:Text)
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Nota Fiscal Valida ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cCodRetNFe	:= ALLTRIM(oXmlResult:_cStat:Text)
				
		
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ 100 - Autorizado o uso da NF-e ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				IF cCodRetNFe == "100"
					nStatNFE	:= 1
		                                           
				ELSEIF ascan(aCodCan, cCodRetNFe) <> 0
					nStatNFE	:= 4
		                                                  
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Motivos que invalidao a Danfe ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				ELSEIF ascan(aCodInvalid, cCodRetNFe) <> 0
					nStatNFE	:= 2
					                      
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ CODIGO E MOTIVOS DE NAO ATENDIMENTO DA SOLICITACAO ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				ELSEIF cCodRetNFe >= '201'
					nStatNFE	:= 3
		
				ENDIF 
			ELSE
				nStatNFE	:= 3
				cMsg		:= "Resposta do SEFAZ desconhecida"+EOL+cXMlRetErro
			ENDIF 
		ELSE
			nStatNFE	:= 3
			cMsg		:= "Falha na Comunicação com o SEFAZ."+EOL+cErro
		ENDIF  
	ELSE
		nStatNFE	:= 3	
		cMsg	:= "Falha na Comunicacao com o Sefaz ou TSS (ws ValidaDanfe)"
	ENDIF
ELSE        
	cMsg	:= "UF e/ou Chave Danfe em Branco"
ENDIF

aRet := {nStatNFE, cMsg, cXMLRet}

Return(aRet)  


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CP01G02  ºAutor  ³ Augusto Ribeiro	 º Data ³  29/03/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Realiza o tramento para nome do Arquivo maior que 200 carc º±±
±±º          ³ renomeando para um arquivo que nao exista na pasta importadoº±±
±±º          ³                                                            º±±
±±ºParametros³ cNome1000                                                  º±±
±±º          ³                                                            º±±
±±ºRetorno   ³ cRet := cNome200                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/     
User Function CP01G02(cNome1000) 
Local cRet	:= ""
Local nMax	:= TAMSX3("Z10_ARQUIV")[1]
Local cPathDest	:= LOWER(ALLTRIM(U_CP01005G("11", "XMLOK"))) //| Path de destino dos arquivos
Local cSeqName	:= "000000"

Default cNome1000	:= ""


cNome1000	:= ALLTRIM(cNome1000)

IF !empty(cNome1000) .AND. LEN(cNome1000) > 200
  
	cRet	:= RIGHT(cNome1000,nMax)
	
	WHILE FILE(cPathDest+cRet) 
		cSeqName	:= soma1(cSeqName)
		
		cRet		:= cSeqName+"_"+RIGHT(cRet,LEN(cRet)-(LEN(cSeqName)+1))		
	ENDDO
	
ENDIF

Return(cRet)
                   


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CP01G03  ºAutor  ³ Augusto Ribeiro	 º Data ³  05/07/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna tipo da Nota fiscal com base no CFOP               º±±
±±º          ³                                                            º±±
±±ºParametros³ xDetalhe =  Array de Objetos do XML da NFe, Node Detalhes  º±±
±±º          ³ ou cChaveDanfe                                             º±±
±±ºRetorno   ³ cRet := 1=Normal;D=Devolucao;B=Beneficiamento              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/     
User Function CP01G03(cEntSai, xDetalhe, cCnpj)
Local cRet
Local nItem, nTotItem
                             
Local aCFOP3 	:= {}
Local cCFBenef
Local aCFBenef
Local cFrBenef
Local aFrBenef
Local lCFBenef	 := .F.
              
Local aAreaZ11
Local cCFDevol	
Local aCFDevol
Local lCFDevol	 := .F.
//Local lDsIgualEm := LEFT(cCnpj,8) == LEFT(SM0->M0_CGC,8)                     

Local aAreaSA2		:= SA2->(GetArea())


Default cCnpj := ""

IF cEntSai == "S"                                      
                      
	cRet		:= "N"

	cCFDevol	:= ALLTRIM(U_CP01005G("12", "CFDEVOL"))
	cCFBenef	:= ALLTRIM(U_CP01005G("12", "CFBENEF"))

ELSEIF cEntSai == "E"
                
	cRet		:= "N"

	cCFDevol	:= ALLTRIM(U_CP01005G("11", "CFDEVOL"))
	cCFBenef	:= ALLTRIM(U_CP01005G("11", "CFBENEF"))
	cFrBenef	:= ALLTRIM(U_CP01005G("11", "FRBENEF"))

ENDIF


IF VALTYPE(xDetalhe) == "A"
	nTotItem	:= LEN(xDetalhe)
          
	FOR nItem := 1 TO nTotItem     
		aadd(aCFOP3, RIGHT(ALLTRIM(xDetalhe[nItem]:_Prod:_CFOP:TEXT),3))	
	NEXT nItem             
	
ELSEIF VALTYPE(xDetalhe) == "C"   
	
	aAreaZ11	:= Z11->(GetArea())	
	
	DBSELECTAREA("Z11")
	Z11->(DBSETORDER(1)) 
	IF Z11->(DBSEEK(XFILIAL("Z11")+cEntSai+xDetalhe))
		WHILE Z11->(!EOF()) .AND.  cEntSai+xDetalhe == Z11->(Z11_TIPARQ+Z11_CHVNFE)	
	           
	       aadd(aCFOP3, RIGHT(Z11->Z11_CFOP,3) )
		
			Z11->(DBSKIP())
		ENDDO	
	ENDIF
	
	
	RestArea(aAreaZ11)	
ENDIF
      
IF LEN(aCFOP3) > 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca CFOPs de Beneficiamento ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !EMPTY(cCFBenef) //.AND. lDsIgualEm
		aCFBenef := U_cpC2A(cCFBenef, "/")
		lCFBenef	:= .T.	
	EndIf	
	
	/*----------------------------------------
		28/05/2019 - Jonatas Oliveira - Compila
		Verifica se existe Fornecedor + Loja
		onde a nota não será de Beneficiamento
	------------------------------------------*/
	If !EMPTY(cFrBenef)
		aFrBenef := U_cpC2A(cFrBenef, "/")
		lCFBenef	:= .T.	
	Endif 
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca CFOPs de Devolução ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !EMPTY(cCFDevol) 
		aCFDevol := U_cpC2A(cCFDevol, "/")
		lCFDevol	:= .T.
	EndIf
                     

	nTotItem	:= LEN(xDetalhe)
	
	DBSELECTAREA("SA2")
	SA2->(DBSETORDER(3))
          
	FOR nItem := 1 TO nTotItem

		cCFOP3 := RIGHT(ALLTRIM(xDetalhe[nItem]:_Prod:_CFOP:TEXT),3)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Beneficiamento ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF lCFBenef	
			IF ASCAN(aCFBenef, cCFOP3) > 0 
				/*----------------------------------------
					28/05/2019 - Jonatas Oliveira - Compila
					Verifica se existe Fornecedor + Loja
					onde a nota não será de Beneficiamento
				------------------------------------------*/
				IF cEntSai == "E" .AND. !EMPTY(cCnpj) .AND. SA2->(DBSEEK(XFILIAL("SA2") + cCnpj)) .AND. ASCAN(aFrBenef, ALLTRIM(SA2->( A2_COD + A2_LOJA ))) > 0
					cRet	:= "N"
					EXIT
				ELSE
					cRet	:= "B"                                                        
					EXIT
				ENDIF 			
			ENDIF    	
		ENDIF	   

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Devolucao      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF lCFDevol	
			IF ASCAN(aCFDevol, cCFOP3) > 0 
				cRet	:= "D"                                                        
				EXIT
			ENDIF    	
		ENDIF		
		
	NEXT nItem
ENDIF

RestArea(aAreaSA2)

Return(cRet) 


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CP01G04  ºAutor  ³ Augusto Ribeiro	 º Data ³  05/07/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao de recuperacao dos codigos de UF do IBGE            º±±
±±º          ³                                                            º±±
±±ºParametros³ ExpC1: Codigo do Estado ou UF                              º±±
±±º          ³ ExpC2: lForceUf                                            º±±
±±ºRetorno   ³ Sigla Estado                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/   
User Function CP01G04(cUF,lForceUF)

Local nX         := 0
Local cRetorno   := ""
Local aUF        := {}
DEFAULT lForceUF := .F.

aadd(aUF,{"RO","11"})
aadd(aUF,{"AC","12"})
aadd(aUF,{"AM","13"})
aadd(aUF,{"RR","14"})
aadd(aUF,{"PA","15"})
aadd(aUF,{"AP","16"})
aadd(aUF,{"TO","17"})
aadd(aUF,{"MA","21"})
aadd(aUF,{"PI","22"})
aadd(aUF,{"CE","23"})
aadd(aUF,{"RN","24"})
aadd(aUF,{"PB","25"})
aadd(aUF,{"PE","26"})
aadd(aUF,{"AL","27"})
aadd(aUF,{"SE","28"})
aadd(aUF,{"BA","29"})
aadd(aUF,{"MG","31"})
aadd(aUF,{"ES","32"})
aadd(aUF,{"RJ","33"})
aadd(aUF,{"SP","35"})
aadd(aUF,{"PR","41"})
aadd(aUF,{"SC","42"})
aadd(aUF,{"RS","43"})
aadd(aUF,{"MS","50"})
aadd(aUF,{"MT","51"})
aadd(aUF,{"GO","52"})
aadd(aUF,{"DF","53"})

If !Empty(cUF)
	nX := aScan(aUF,{|x| x[1] == cUF})
	If nX == 0
		nX := aScan(aUF,{|x| x[2] == cUF})
		If nX <> 0
			cRetorno := aUF[nX][1]
		EndIf
	Else
		cRetorno := aUF[nX][IIF(!lForceUF,2,1)]
	EndIf
Else
	cRetorno := aUF
EndIf
Return(cRetorno)   


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CP01G05  ºAutor  ³ Jonatas Oliveira   º Data ³  16/05/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna NF, Serie e Item da nota fical de origem           º±±
±±º          ³                                                            º±±
±±ºParametros³ cChvNfe, cCodPro                                           º±±
±±º          ³                                                            º±±
±±ºRetorno   ³ aRet := {cNumNota, cSerie, ITEM}                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/     
User Function CP01G05(cChvNfe, cCodPro) 
Local aRet		:= {}
Local cQryNFRef 	:= ""       


cQryNFRef	+= " SELECT F2_DOC, F2_SERIE, "
cQryNFRef	+= " 		SD2A.D2_ITEM AS A_ITEM, SD2A.D2_COD AS A_COD, "
cQryNFRef	+= " 		SD2B.D2_ITEM AS B_ITEM, SD2B.D2_COD AS B_COD "
cQryNFRef	+= " FROM "+RetSqlName("SF2")+" SF2 "
cQryNFRef	+= " LEFT JOIN "+RetSqlName("SD2")+" SD2A "
cQryNFRef	+= " 	ON SF2.F2_FILIAL = SD2A.D2_FILIAL "
cQryNFRef	+= " 	AND F2_DOC = SD2A.D2_DOC "
cQryNFRef	+= " 	AND F2_SERIE = SD2A.D2_SERIE "
cQryNFRef	+= " 	AND SD2A.D2_COD = '"+cCodPro+"' "
cQryNFRef	+= " 	AND  SF2.D_E_L_E_T_ = '' "
cQryNFRef	+= " LEFT JOIN  "+RetSqlName("SA7")+" SA7 "
cQryNFRef	+= " 	ON A7_FILIAL = '"+XFILIAL("SA7")+"' "
cQryNFRef	+= " 	AND A7_CLIENTE = F2_CLIENTE "
cQryNFRef	+= " 	AND A7_LOJA = F2_LOJA "
cQryNFRef	+= " 	AND A7_CODCLI = '"+cCodPro+"' "
cQryNFRef	+= " 	AND SA7.D_E_L_E_T_ = '' "
cQryNFRef	+= " LEFT JOIN "+RetSqlName("SD2")+" SD2B "
cQryNFRef	+= " 	ON SF2.F2_FILIAL = SD2B.D2_FILIAL "
cQryNFRef	+= " 	AND F2_DOC = SD2B.D2_DOC "
cQryNFRef	+= " 	AND F2_SERIE = SD2B.D2_SERIE "
cQryNFRef	+= " 	AND SD2B.D2_COD = A7_PRODUTO "    
cQryNFRef	+= " 	AND  SF2.D_E_L_E_T_ = '' "
cQryNFRef	+= " WHERE F2_FILIAL = '"+XFILIAL("SF2")+"' "
cQryNFRef	+= " AND F2_CHVNFE = '"+cChvNfe+"' "
cQryNFRef	+= " AND  SF2.D_E_L_E_T_ = '' "

If Select("TREF") > 0
	TREF->(DbCloseArea())
EndIf
          
cQryNFRef	:= ChangeQuery(cQryNFRef)
                   
dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQryNFRef),'TREF')

IF TREF->(!EOF())
	
	IF !EMPTY(TREF->A_ITEM)  

		aadd(aRet, TREF->F2_DOC)
		aadd(aRet, TREF->F2_SERIE)
		aadd(aRet, TREF->A_ITEM)
		
	ELSEIF !EMPTY(TREF->B_ITEM)  

		aadd(aRet, TREF->F2_DOC)
		aadd(aRet, TREF->F2_SERIE)
		aadd(aRet, TREF->B_ITEM)
	ENDIF
ENDIF

TREF->(DbCloseArea())
	
Return(aRet)
                   



/*-------------------------------------------------------------------------------------------------------

*****************
Códigos de mensagens de autorização, rejeição e denegação de Notas Fiscais eletrônicas (NF-e)            
*****************

CÓDIGO E RESULTADO DO PROCESSAMENTO DA SOLICITAÇÃO
100 - Autorizado o uso da NF-e
101 - Cancelamento de NF-e homologado
102 - Inutilização de número homologado
103 - Lote recebido com sucesso
104 - Lote processado
105 - Lote em processamento
106 - Lote não localizado
107 - Serviço em Operação
108 - Serviço Paralisado Momentaneamente (curto prazo)
109 - Serviço Paralisado sem Previsão
110 - Uso Denegado
111 - Consulta cadastro com uma ocorrência
112 - Consulta cadastro com mais de uma ocorrência

CÓDIGO E MOTIVOS DE NÃO ATENDIMENTO DA SOLICITAÇÃO
201 Rejeição: O numero máximo de numeração de NF-e a inutilizar ultrapassou o limite
202 Rejeição: Falha no reconhecimento da autoria ou integridade do arquivo digital
203 Rejeição: Emissor não habilitado para emissão da NF-e
204 Rejeição: Duplicidade de NF-e
205 Rejeição: NF-e está denegada na base de dados da SEFAZ
206 Rejeição: NF-e já está inutilizada na Base de dados da SEFAZ
207 Rejeição: CNPJ do emitente inválido
208 Rejeição: CNPJ do destinatário inválido
209 Rejeição: IE do emitente inválida
210 Rejeição: IE do destinatário inválida
211 Rejeição: IE do substituto inválida
212 Rejeição: Data de emissão NF-e posterior a data de recebimento
213 Rejeição: CNPJ-Base do Emitente difere do CNPJ-Base do Certificado Digital
214 Rejeição: Tamanho da mensagem excedeu o limite estabelecido
215 Rejeição: Falha no schema XML
216 Rejeição: Chave de Acesso difere da cadastrada
217 Rejeição: NF-e não consta na base de dados da SEFAZ
218 Rejeição: NF-e já esta cancelada na base de dados da SEFAZ
219 Rejeição: Circulação da NF-e verificada
220 Rejeição: NF-e autorizada há mais de 60 dias
221 Rejeição: Confirmado o recebimento da NF-e pelo destinatário
222 Rejeição: Protocolo de Autorização de Uso difere do cadastrado
223 Rejeição: CNPJ do transmissor do lote difere do CNPJ do transmissor da consulta
224 Rejeição: A faixa inicial é maior que a faixa final
225 Rejeição: Falha no Schema XML da NFe
226 Rejeição: Código da UF do Emitente diverge da UF autorizadora
227 Rejeição: Erro na Chave de Acesso - Campo ID
228 Rejeição: Data de Emissão muito atrasada
229 Rejeição: IE do emitente não informada
230 Rejeição: IE do emitente não cadastrada
231 Rejeição: IE do emitente não vinculada ao CNPJ
232 Rejeição: IE do destinatário não informada
233 Rejeição: IE do destinatário não cadastrada
234 Rejeição: IE do destinatário não vinculada ao CNPJ
235 Rejeição: Inscrição SUFRAMA inválida
236 Rejeição: Chave de Acesso com dígito verificador inválido
237 Rejeição: CPF do destinatário inválido
238 Rejeição: Cabeçalho - Versão do arquivo XML superior a Versão vigente
239 Rejeição: Cabeçalho - Versão do arquivo XML não suportada
240 Rejeição: Cancelamento/Inutilização - Irregularidade Fiscal do Emitente
241 Rejeição: Um número da faixa já foi utilizado
242 Rejeição: Cabeçalho - Falha no Schema XML
243 Rejeição: XML Mal Formado
244 Rejeição: CNPJ do Certificado Digital difere do CNPJ da Matriz e do CNPJ do Emitente
245 Rejeição: CNPJ Emitente não cadastrado
246 Rejeição: CNPJ Destinatário não cadastrado
247 Rejeição: Sigla da UF do Emitente diverge da UF autorizadora
248 Rejeição: UF do Recibo diverge da UF autorizadora
249 Rejeição: UF da Chave de Acesso diverge da UF autorizadora
250 Rejeição: UF diverge da UF autorizadora
251 Rejeição: UF/Município destinatário não pertence a SUFRAMA
252 Rejeição: Ambiente informado diverge do Ambiente de recebimento
253 Rejeição: Digito Verificador da chave de acesso composta inválida
254 Rejeição: NF-e referenciada não informada para NF-e complementar
255 Rejeição: Informada mais de uma NF-e referenciada para NF-e complementar
256 Rejeição: Uma NF-e da faixa já está inutilizada na Base de dados da SEFAZ
257 Rejeição: Solicitante não habilitado para emissão da NF-e
258 Rejeição: CNPJ da consulta inválido
259 Rejeição: CNPJ da consulta não cadastrado como contribuinte na UF
260 Rejeição: IE da consulta inválida
261 Rejeição: IE da consulta não cadastrada como contribuinte na UF
262 Rejeição: UF não fornece consulta por CPF
263 Rejeição: CPF da consulta inválido
264 Rejeição: CPF da consulta não cadastrado como contribuinte na UF
265 Rejeição: Sigla da UF da consulta difere da UF do Web Service
266 Rejeição: Série utilizada não permitida no Web Service
267 Rejeição: NF Complementar referencia uma NF-e inexistente
268 Rejeição: NF Complementar referencia uma outra NF-e Complementar
269 Rejeição: CNPJ Emitente da NF Complementar difere do CNPJ da NF Referenciada
270 Rejeição: Código Município do Fato Gerador: dígito inválido
271 Rejeição: Código Município do Fato Gerador: difere da UF do emitente
272 Rejeição: Código Município do Emitente: dígito inválido
273 Rejeição: Código Município do Emitente: difere da UF do emitente
274 Rejeição: Código Município do Destinatário: dígito inválido
275 Rejeição: Código Município do Destinatário: difere da UF do Destinatário
276 Rejeição: Código Município do Local de Retirada: dígito inválido
277 Rejeição: Código Município do Local de Retirada: difere da UF do Local de Retirada
278 Rejeição: Código Município do Local de Entrega: dígito inválido
279 Rejeição: Código Município do Local de Entrega: difere da UF do Local de Entrega
280 Rejeição: Certificado Transmissor inválido
281 Rejeição: Certificado Transmissor Data Validade
282 Rejeição: Certificado Transmissor sem CNPJ
283 Rejeição: Certificado Transmissor - erro Cadeia de Certificação
284 Rejeição: Certificado Transmissor revogado
285 Rejeição: Certificado Transmissor difere ICP-Brasil
286 Rejeição: Certificado Transmissor erro no acesso a LCR
287 Rejeição: Código Município do FG - ISSQN: dígito inválido
288 Rejeição: Código Município do FG - Transporte: dígito inválido
289 Rejeição: Código da UF informada diverge da UF solicitada
290 Rejeição: Certificado Assinatura inválido
291 Rejeição: Certificado Assinatura Data Validade
292 Rejeição: Certificado Assinatura sem CNPJ
293 Rejeição: Certificado Assinatura - erro Cadeia de Certificação
294 Rejeição: Certificado Assinatura revogado
295 Rejeição: Certificado Assinatura difere ICP-Brasil
296 Rejeição: Certificado Assinatura erro no acesso a LCR
297 Rejeição: Assinatura difere do calculado
298 Rejeição: Assinatura difere do padrão do Projeto
299 Rejeição: XML da área de cabeçalho com codificação diferente de UTF-8
401 Rejeição: CPF do remetente inválido
402 Rejeição: XML da área de dados com codificação diferente de UTF-8
403 Rejeição: O grupo de informações da NF-e avulsa é de uso exclusivo do Fisco
404 Rejeição: Uso de prefixo de namespace não permitido
405 Rejeição: Código do país do emitente: dígito inválido
406 Rejeição: Código do país do destinatário: dígito inválido
407 Rejeição: O CPF só pode ser informado no campo emitente para a NF-e avulsa
999 Rejeição: Erro não catalogado (informar a mensagem de erro capturado no tratamento da exceção)

CÓDIGO E MOTIVOS DE DENEGAÇÃO DE USO
301 Uso Denegado : Irregularidade fiscal do emitente
302 Uso Denegado : Irregularidade fiscal do destinatário
OBS.:
1. Recomendamos a não utilização de caracteres especiais ou acentuação nos textos das mensagens de erro.
2. Recomendamos que o campo xMotivo da mensagem de erro para o código 999 seja informado com a mensagem de erro do aplicativo ou do sistema que gerou a exceção não prevista.

*/


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CP01EML  ºAutor  ³ Jonatas Oliveira   º Data ³  06/10/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processa Importacao de XML via Schedule                    º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ºPARAMETROS³ {cEmp, cFil }                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/     
User Function CP01EML(aParam)
Local aParam

Default aParam := {}

Conout("###| U_CP01EML - INICIO: "+DTOC(DATE())+" "+TIME())

PREPARE ENVIRONMENT EMPRESA aParam[1] FILIAL aParam[2]
	U_CP01007()//| Baixa Email
	U_CP01004("DIR")//|Move para pasta TEMP e processa a importacao
RESET ENVIRONMENT	

Conout("###| U_CP01EML - FIM: "+DTOC(DATE())+" "+TIME())

Return()

/*========================================================================
| Função...: CP01GTS
| Descrição: Interface para captação de TES quando não configurado 
|
| Nota.....:
|
| ========================================================================
| Desenvolvido por: Jonatas Oliveira
| Data ...........: 26/01/2015
======================================================================== */
User Function CP01GTS()
	Local nOpcDsd:= 0
	Local cCondPgto:= Space(3), nParceDsd:= 0, cValorDsd := "T"
	Local nPerioDsd:= 0 , nOrdSE1 := IndexOrd("SF4")
	Local GetList:={}
	Local oDlg, oVlDsd
	Local cHistDsd := ""
	LOCAL aArray := {}
	Local aRet	:= {.f., ""}
	Local aCpoLog	:= {}
	Local _lRet		:= .T.
	Local _nVlrParc	:= 0
			
	cHistDsd := SPACE(TAMSX3("F4_CODIGO")[1])
	
	DEFINE MSDIALOG oDlg FROM	0,0 TO 500,600 TITLE "Tipo de Entrada/Saída" PIXEL
	
	@ 004, 007 TO 300, 300 OF oDlg PIXEL
	
	@ 010, 014 SAY "Nota Fiscal :"+Z10->Z10_NUMNFE+" "  				SIZE 190, 17 OF oDlg PIXEL
	@ 024, 014 SAY "Serie       :"+Z10->Z10_SERIE+" "  					SIZE 190, 17 OF oDlg PIXEL
	@ 038, 014 SAY "Emitente    :"+Z10->Z10_RAZAO+" " 		 			SIZE 190, 17 OF oDlg PIXEL
	@ 052, 014 SAY "TES : Produto "+ALLTRIM(Z11->Z11_CODPRO)+" | "+ALLTRIM(Z11->Z11_DESPRO)	SIZE 190, 17 OF oDlg PIXEL

			
	@ 066, 014 MSGET  cHistDsd		F3 "SF4"	Picture "@!";
		SIZE 056, 18 OF oDlg PIXEL
	DEFINE SBUTTON FROM 07, 136 TYPE 1 ACTION ;
		{||nOpcDsd:=1,IF(.T. ,oDlg:End(),nOpcDsd:=0)} ENABLE OF oDlg
	DEFINE SBUTTON FROM 23, 136 TYPE 2 ACTION {||nOpcDsd:=9 ,oDlg:End()} ENABLE OF oDlg
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
	IF nOpcDsd == 9
		//Alert("Cancelado pelo Operador")
		cHistDsd := SPACE(TAMSX3("F4_CODIGO")[1])
	ENDIF
	
Return(cHistDsd)



/*========================================================================
| Função...: CP01GTS
| Descrição: Interface para captação de Cliente quando não configurado 
|
| Nota.....:
|
| ========================================================================
| Desenvolvido por: Jonatas Oliveira
| Data ...........: 26/01/2015
======================================================================== */
User Function CP01GEX()
	Local nOpcDsd	:= 0
	Local cCondPgto	:= Space(3), nParceDsd:= 0, cValorDsd := "T"
	Local nPerioDsd	:= 0 , nOrdSE1 := IndexOrd("SA1")
	Local GetList	:={}
	Local oDlg, oVlDsd
	Local cCodCliEx := SPACE(TAMSX3("A1_COD")[1])
	Local cLojCliEx := SPACE(TAMSX3("A1_LOJA")[1])
	LOCAL aArray 	:= {}
	Local _aRet		:= {"", ""}
	Local aCpoLog	:= {}
	Local _lRet		:= .T.
	Local _nVlrParc	:= 0
			
	
	DEFINE MSDIALOG oDlg FROM	0,0 TO 500,600 TITLE "Cadastro de Clientes" PIXEL
	
	@ 004, 007 TO 300, 300 OF oDlg PIXEL
	
	@ 010, 014 SAY "Nota Fiscal :"+Z10->Z10_NUMNFE+" "  				SIZE 190, 17 OF oDlg PIXEL
	@ 024, 014 SAY "Serie       :"+Z10->Z10_SERIE+" "  					SIZE 190, 17 OF oDlg PIXEL
	@ 038, 014 SAY "Emitente    :"+Z10->Z10_RAZAO+" " 		 			SIZE 190, 17 OF oDlg PIXEL
	@ 052, 014 SAY "Codigo/Loja Cliente "								SIZE 190, 17 OF oDlg PIXEL
		
			
	@ 080, 014 MSGET  cCodCliEx		F3 "SA1"	Picture "@!"	SIZE 056, 18 OF oDlg PIXEL COLOR CLR_HBLUE
	@ 080, 158 MSGET  cLojCliEx					Picture "@!"	SIZE 026, 18 OF oDlg PIXEL COLOR CLR_HBLUE
	DEFINE SBUTTON FROM 07, 136 TYPE 1 ACTION ;
		{||nOpcDsd:=1,IF(.T. ,oDlg:End(),nOpcDsd:=0)} ENABLE OF oDlg
	DEFINE SBUTTON FROM 23, 136 TYPE 2 ACTION {||nOpcDsd:=9 ,oDlg:End()} ENABLE OF oDlg
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
	IF nOpcDsd == 9
		//Alert("Cancelado pelo Operador")
		cCodCliEx := SPACE(TAMSX3("A1_COD")[1])
		cLojCliEx := SPACE(TAMSX3("A1_LOJA")[1])
	ELSEIF nOpcDsd == 1 .AND. !EMPTY(cCodCliEx) .AND. !EMPTY(cLojCliEx)
		_aRet := {cCodCliEx,cLojCliEx}		
	ENDIF
	
Return(_aRet)

User Function CP01GEXF()
	Local nOpcDsd	:= 0
	Local cCondPgto	:= Space(3), nParceDsd:= 0, cValorDsd := "T"
	Local nPerioDsd	:= 0 , nOrdSE1 := IndexOrd("SA2")
	Local GetList	:={}
	Local oDlg, oVlDsd
	Local cCodCliEx := SPACE(TAMSX3("A2_COD")[1])
	Local cLojCliEx := SPACE(TAMSX3("A2_LOJA")[1])
	LOCAL aArray 	:= {}
	Local _aRet		:= {"", ""}
	Local aCpoLog	:= {}
	Local _lRet		:= .T.
	Local _nVlrParc	:= 0
			
	
	DEFINE MSDIALOG oDlg FROM	0,0 TO 500,600 TITLE "Cadastro de Fornecedor" PIXEL
	
	@ 004, 007 TO 300, 300 OF oDlg PIXEL
	
	@ 010, 014 SAY "Nota Fiscal :"+Z10->Z10_NUMNFE+" "  				SIZE 190, 17 OF oDlg PIXEL
	@ 024, 014 SAY "Serie       :"+Z10->Z10_SERIE+" "  					SIZE 190, 17 OF oDlg PIXEL
	@ 038, 014 SAY "Emitente    :"+Z10->Z10_RAZAO+" " 		 			SIZE 190, 17 OF oDlg PIXEL
	@ 052, 014 SAY "Codigo/Loja Cliente "								SIZE 190, 17 OF oDlg PIXEL
		
			
	@ 080, 014 MSGET  cCodCliEx		F3 "SA2"	Picture "@!"	SIZE 056, 18 OF oDlg PIXEL COLOR CLR_HBLUE
	@ 080, 158 MSGET  cLojCliEx					Picture "@!"	SIZE 026, 18 OF oDlg PIXEL COLOR CLR_HBLUE
	DEFINE SBUTTON FROM 07, 136 TYPE 1 ACTION ;
		{||nOpcDsd:=1,IF(.T. ,oDlg:End(),nOpcDsd:=0)} ENABLE OF oDlg
	DEFINE SBUTTON FROM 23, 136 TYPE 2 ACTION {||nOpcDsd:=9 ,oDlg:End()} ENABLE OF oDlg
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
	IF nOpcDsd == 9
		//Alert("Cancelado pelo Operador")
		cCodCliEx := SPACE(TAMSX3("A2_COD")[1])
		cLojCliEx := SPACE(TAMSX3("A2_LOJA")[1])
	ELSEIF nOpcDsd == 1 .AND. !EMPTY(cCodCliEx) .AND. !EMPTY(cLojCliEx)
		_aRet := {cCodCliEx,cLojCliEx}		
	ENDIF
	
Return(_aRet)

User Function CP01GAJ()
	Local cExpCorr	:= ""
	
	DBSELECTAREA("Z07")
	Z07->(DBSETORDER(1))
	Z07->(DBGOTOP())
	
	WHILE Z07->(!EOF())
		cExpCorr	:= CorrigExp(Z07->Z07_FILTRO)
		
		RECLOCK("Z07",.F.)
			Z07->Z07_FILTRO := cExpCorr
		MSUNLOCK()
		
		Z07->(DBSKIP())
	ENDDO	
	
	Alert("Finalizado")
Return()




Static Function CorrigExp(cExp)
	Local aReplace	:= {}
	Local nI
	
	/*
	aadd(aReplace, {"F1_", "SF1->F1_", "SF1->"})
	aadd(aReplace, {"D1_", "SD1->D1_", "SD1->"})
	aadd(aReplace, {"B1_", "SB1->B1_", "SB1->"})
	aadd(aReplace, {"A1_", "SA1->A1_", "SA1->"})
	aadd(aReplace, {"A2_", "SA2->A2_", "SA2->"})
	aadd(aReplace, {"Z10_", "Z10->Z10_", "Z10->"})
	aadd(aReplace, {"Z11_", "Z11->Z11_", "Z11->"})
	*/
	aadd(aReplace, {"=", "==", "=="})
	aadd(aReplace, {"<==", "<=", "<="})
	aadd(aReplace, {">==", ">=", ">="})
	
	
	FOR nI := 1 TO Len(aReplace)
		
		
		cExp := Replace(cExp, aReplace[nI,1], aReplace[nI,2])
		cExp := Replace(cExp, aReplace[nI,3]+aReplace[nI,3], aReplace[nI,3])
		
		/*		
		cExp := Replace(cExp, "AND", ".AND.")
		cExp := Replace(cExp, "..AND..", ".AND.")
		
		
		cExp := Replace(cExp, "OR", ".OR.")
		cExp := Replace(cExp, "..OR..", ".OR.")
		*/		
	Next nI
	
	
	
	
Return(cExp)


/*/{Protheus.doc} A103Devol
Função responsavel pela devolução
@author Jonatas Oliveira | www.compila.com.br
@since 01/08/2019
@version 1.0
/*/
User Function A103Devol(cAlias,nReg,nOpcx)
	// o conteudo da função A103Devol foi migrada para o fonte MATA103R.PRX com novo nome de funcao SA103Dev 
	U_SA103Dev(cAlias,nReg,nOpcx)

Return .T.



/*/{Protheus.doc} SA103Dev
//TODO Permite selecionar a nota de remessa simbolica
@author Henry Fila
@since 25/05/2018
@version 1.0
@return ${return}, ${return_description}
@param cAlias, characters, Alias da tabela corrente
@param nReg, numeric, recno do registro
@param nOpcx, numeric, opcao selecionada
@type function
/*/
User Function SA103Dev(cAlias,nReg,nOpcx)

Local oTmpTable
Local aFieldView:= {}
Local aColsMB	:= {}
Local dDataDe	:= stod("")
Local dDataAte	:= stod("")
Local cCliente	:= ""
Local cLoja		:= ""
Local cAliasTRB	:= ""
Local cAliasQRY	:= ""
Local cDocSF2	:= ""
Local lCliente	:= .F.
Local lFilCliFor:= .T.
Local lAllCliFor:= .T.
Local lDocVincul:= .F.
Local lFlagDev	:= SuperGetMv("MV_FLAGDEV",.F.,.F.) 

Private lLoop	:= .T.

If INCLUI

	cCliente := CriaVar("F2_CLIENTE",.F.)
	cLoja := CriaVar("F2_LOJA",.F.)

	// tela de selecao de filtros
	If A103FRet(@lCliente,@dDataDe,@dDataAte,@lFilCliFor,@lAllCliFor,@lDocVincul,@cCliente,@cLoja)
	
		// define os campos a serem apresentadas no browse
		aFieldView := A103FldBrw(lCliente,lDocVincul)

		//
		// abre uma query com os filtros selecionados
		//

	while lLoop
		lLoop := .F.
		cDocSF2 := ""
		cAliasQRY := A103QryNF(lDocVincul, cCliente, cLoja, dDataDe, dDataAte, lFilCliFor, lAllCliFor, lFlagDev)
		If Empty((cAliasQRY)->F2_DOC)
			Help("",1,"A103NDOCDEV",,"Não foi encontrado documentos de acordo com filtro informado",1,0) //"Não foi encontrado documentos de acordo com filtro informado"
		Else
			// definir a estrutura da tabela temporia baseada no SX3
			aStrTMP := A103DFldQ(cAliasQRY)

			// definir os indices baseado na tabela principal a query
			aIdxTMP := A103DIdxQ(lCliente, lDocVincul)
			
			// cria a tabela temporaria
			cAliasTRB := A103NewTMP(@oTmpTable,aStrTMP,aIdxTMP)
			If Empty(cAliasTRB)
				Help("",1,"A103NDOCDEV",,"Não foi encontrado documentos de acordo com filtro informado",1,0) //"Não foi encontrado documentos de acordo com filtro informado"
			Else
				// insiro os registros da Query na tabela temporaria
				A103InsTMP(cAliasQRY ,aStrTMP ,cAliasTRB ,aStrTMP)

				// definicao das colunas da markbrowse
				aColsMB := MontColMb(aFieldView,aStrTMP)
			
				// definicao dos indices markbrowse
				aIdxMB := MontIdxMb(aIdxTMP ,aStrTMP)
			
				// por cliente/fornecedor - TBrowse	
				If lCliente
					nOpcao := u_CpBrwMrk( STR0099+" - "+AllTrim(RetTitle("F2_CLIENTE"))+" / "+AllTrim(RetTitle("F1_FORNECE")) ,cAliasTRB ,lCliente ,aIdxMB ,aColsMB ,,lCliente )
				
				// por documento - MaWndBrowse
				Else
					nOpcao := u_CpBrwMrk( STR0099+" - "+STR0184 ,cAliasTRB ,,aIdxMB ,aColsMB ,,lCliente )
				EndIf

				// executa loop da temporaria e executa as marcadas
				If nOpcao == 1
					dbSelectArea("SF2")
					dbSetOrder(1)
					If dbSeek(xFilial("SF2")+(cAliasTRB)->(F2_DOC+F2_SERIE))
						U_A103PcDv("SF2",SF2->(Recno()),nOpcx,lCliente,SF2->F2_CLIENTE,SF2->F2_LOJA,cDocSF2,lFlagDev)
					EndIf
				ElseIf nOpcao == 2
					(cAliasTRB)->(dbGoTop())
					While (cAliasTRB)->(!Eof())
						If !Empty((cAliasTRB)->TRB_OK)
							cDocSF2 += IIF(Len(cDocSF2)>0,",","")+"'"+(cAliasTRB)->F2_DOC+(cAliasTRB)->F2_SERIE+"'"
						EndIF
						
						(cAliasTRB)->(dbSkip())
					EndDo
					If !Empty(cDocSF2)
						cDocSF2 := "("+SubStr(cDocSF2,1,Len(cDocSF2))+")"
						U_A103PcDv(cAlias,,nOpcx,lCliente,cCliente,cLoja,cDocSF2,lFlagDev)
					EndIf

				EndIf
				
				(cAliasQRY)->(dbCloseArea())
				oTmpTable:Delete()
				oTmpTable := NIL
				
			EndIf

		EndIf // Empty(cAliasTRB)
	enddo
	EndIf // A103FRet(...
EndIf // INCLUI
Inclui := !Inclui

Return


/*/{Protheus.doc} A103FRet
//TODO Filtro para retornar de doctos fiscais.
@author Eduardo de Souza
@since 20/07/2005
@version 1.0
@return ${return}, ${return_description}
@param lCliFor, logical, descricao
@param dDataDe, date, descricao
@param dDataAte, date, descricao
@param lFilCliFor, logical, descricao
@param lAllCliFor, logical, descricao
@param lDocVincul, logical, descricao
@param cCliente, characters, descricao
@param cLoja, characters, descricao
@type function
/*/
Static Function A103FRet(lCliFor,dDataDe,dDataAte,lFilCliFor,lAllCliFor,lDocVincul,cCliente, cLoja)

Local oDlgEsp
Local oCliente
Local oDocto
Local oDocVinculo
Local lDocto	:= .T.
Local lMotObrig := X3Obrigat("F1_MOTRET")
Local nOpcao	:= 0
Local aSize		:= MsAdvSize(.F.)
Private cCodCli	:= CriaVar("F2_CLIENTE",.F.)
Private cLojCli	:= CriaVar("F2_LOJA",.F.)
Private cCodFor	:= CriaVar("F1_FORNECE",.F.)
Private cLojFor	:= CriaVar("F1_LOJA",.F.)
Private cDescRet:= CriaVar("DHI_DESCRI",.F.)
Private cMotRet	:= CriaVar("DHI_CODIGO",.F.)
Private cHistRet:= CriaVar("F1_HISTRET",.F.)
Private oMemoRet:= Nil

DEFAULT lDocVincul := .F.

DEFINE MSDIALOG oDlgEsp From aSize[7],0 To aSize[6]/1.5,aSize[5]/2 OF oMainWnd PIXEL TITLE STR0099

@ 06,005 SAY RetTitle("F2_CLIENTE") PIXEL
@ 05,040 MSGET cCodCli PICTURE PesqPict("SF2","F2_CLIENTE") F3 'SA1' SIZE 95,10 OF oDlgEsp PIXEL VALID Vazio() .Or. ExistCpo('SA1',cCodCli+RTrim(cLojCli),1)  WHEN Empty(cCodFor) HASBUTTON

@ 06,145 SAY RetTitle("F2_LOJA") PIXEL
@ 05,160 MSGET cLojCli PICTURE PesqPict("SF2","F2_LOJA") SIZE 20,10 OF oDlgEsp PIXEL VALID Vazio() .Or. ExistCpo('SA1',cCodCli+RTrim(cLojCli),1)  WHEN Empty(cLojFor) HASBUTTON

@ 21,005 SAY RetTitle("F1_FORNECE") PIXEL
@ 20,040 MSGET cCodFor PICTURE PesqPict("SF1","F1_FORNECE") F3 'FOR' SIZE 95, 10 OF oDlgEsp PIXEL VALID Vazio() .Or. ExistCpo('SA2',cCodFor+RTrim(cLojFor),1)  WHEN Empty(cCodCli) HASBUTTON

@ 21,145 SAY RetTitle("F1_LOJA") PIXEL
@ 20,160 MSGET cLojFor PICTURE PesqPict("SF1","F1_LOJA") SIZE 20, 10 OF oDlgEsp PIXEL VALID Vazio() .Or. ExistCpo('SA2',cCodFor+RTrim(cLojFor),1) WHEN Empty(cLojCli) HASBUTTON

@ 21,190 CHECKBOX oDocVinculo VAR lDocVincul PROMPT "Pesquisa por Documento Vinculado"  SIZE 100,010 OF oDlgEsp PIXEL //"Pesquisa por Documento Vinculado"

@ 36,05 SAY STR0181 PIXEL
@ 35,40 MSGET dDataDe PICTURE "@D" SIZE 60, 10 OF oDlgEsp PIXEL HASBUTTON

@ 36,120 SAY STR0182 PIXEL
@ 35,160 MSGET dDataAte PICTURE "@D" SIZE 60, 10 OF oDlgEsp PIXEL HASBUTTON

@ 060,005 TO __DlgHeight(oDlgEsp)-120,__DlgWidth(oDlgEsp)-5 LABEL STR0185 OF oDlgEsp PIXEL // 'Tipo de Selecao'

//-- 'Cliente'
@ 75,010 CHECKBOX oCliente VAR lCliFor PROMPT AllTrim(RetTitle("F2_CLIENTE"))+" / "+AllTrim(RetTitle("F1_FORNECE")) SIZE 100,010 ON CLICK( lDocto := .F., oDocto:Refresh() ) OF oDlgEsp PIXEL
//-- 'Documento'
@ 75,__DlgWidth(oDlgEsp)-60 CHECKBOX oDocto VAR lDocto PROMPT OemToAnsi(STR0184) SIZE 50,010 ON CLICK( lCliFor := .F., oCliente:Refresh() ) OF oDlgEsp PIXEL

@ __DlgHeight(oDlgEsp)-110,005 TO __DlgHeight(oDlgEsp)-025,__DlgWidth(oDlgEsp)-5 LABEL STR0427 OF oDlgEsp PIXEL // 'Motivo do retorno'

@ __DlgHeight(oDlgEsp)-94,010 SAY RetTitle("F1_MOTRET") PIXEL
@ __DlgHeight(oDlgEsp)-95,040 MSGET cMotRet SIZE 95, 10 OF oDlgEsp F3 "DHI" PIXEL VALID;
 (cDescRet:=Posicione("DHI",1,xFilial("DHI")+cMotRet,"DHI_DESCRI"), Vazio() .Or. ExistCpo('DHI',cMotRet,1)) HASBUTTON

@ __DlgHeight(oDlgEsp)-95,145 MSGET cDescRet SIZE __DlgWidth(oDlgEsp)-165, 10 OF oDlgEsp PIXEL VALID Vazio() WHEN .F. HASBUTTON

@ __DlgHeight(oDlgEsp)-70,010 SAY RetTitle("F1_HISTRET") PIXEL
@ __DlgHeight(oDlgEsp)-71,040 GET oMemoRet VAR cHistRet Of oDlgEsp MEMO size __DlgWidth(oDlgEsp)-60,37 pixel 

DEFINE SBUTTON FROM 05,__DlgWidth(oDlgEsp)-35 TYPE 1 OF oDlgEsp ENABLE PIXEL ACTION ;
Eval({||cCliente := IIF(Empty(cCodCli),cCodFor,cCodCli),;
		cLoja    := IIF(Empty(cLojCli),cLojFor,cLojCli),;
		IIF(Empty(cCliente).And.Empty(cLoja),lAllCliFor:=.T.,lAllCliFor:=.F.),;
		IIF(!Empty(cCodCli),lFilCliFor:=.T.,lFilCliFor:=.F.),.t.}).and.;
		If(Iif(!Empty(cMotRet),.T.,Iif(lMotObrig,(MsgAlert(STR0428,"MATA103"),.F.),.T.)) .And.	; //"Informe um código de motivo valido."
			((!Empty(cCliente)     .And.	;
			!Empty(cLoja)		 .And.	;
			!Empty(dDataDe)		 .And.	;
			!Empty(dDataAte)	 .And. 	;
			lCliFor)			 .Or.	;
			lDocto),(MT103SetRet(cMotRet,cHistRet),nOpcao := 1,oDlgEsp:End()),.F.)

DEFINE SBUTTON FROM 20,__DlgWidth(oDlgEsp)-35 TYPE 2 OF oDlgEsp ENABLE PIXEL ACTION (nOpcao := 0,oDlgEsp:End())

ACTIVATE MSDIALOG oDlgEsp CENTERED

Return ( nOpcao == 1 )



/*/{Protheus.doc} A103FldBrw
//TODO Define os campos(colunas) que serao apresentados na markbrowse.
@author reynaldo
@since 04/06/2018
@version 1.0
@return ${return}, ${return_description}
@param lCliente, logical, descricao
@param lDocVincul, logical, descricao
@type function
/*/
Static Function A103FldBrw(lCliente,lDocVincul)
Local aArea		:= {}
Local aFields	:= {}
Local aStruct	:= {} 
Local aStrOrig	:= {}
Local nCnt		:= 0
Local lMT103CAM	:= Existblock("MT103CAM")
Local cCampos	:= ""

	If lCliente
		If lDocVincul
			aFields := {"DH_DOC", "DH_SERIE"}
		Else
			aFields := {"F2_DOC", "F2_SERIE"}
			If lMT103CAM
				cCampos := ExecBlock("MT103CAM",.F.,.F.)
				If !Empty(cCampos)
					aStrOrig := SF2->(dbStruct())
					For nCnt := 1 To Len(aStrOrig)
						If AllTrim(aStrOrig[nCnt,1]) $ cCampos
							aAdd(aFields, aStrOrig[nCnt,1])
						EndIf
					Next nCnt
				EndIf
			EndIf
		EndIf
	Else
		If lDocVincul
		
			aFields := {"DH_SERIE" ,"DH_DOC" ,"DH_CLIENTE" ,"DH_LOJACLI" ,"DH_FORNECE" ,"DH_LOJAFOR" ,"DH_DTDIGIT"}
		Else
			aArea := GetArea()
			DbSelectArea("SX3")
			DbSetOrder(1)
			MsSeek("SF2")
			While !Eof() .And. SX3->X3_ARQUIVO == "SF2"
			    If SX3->X3_BROWSE == "S" 
					Aadd( aFields, Alltrim(SX3->X3_CAMPO) )
				EndIf
				SX3->(DbSkip())
			EndDo
			RestArea(aArea)
		EndIf
	EndIf
	
aSize(aStruct,0) 
aStruct := NIL 
aSize(aStrOrig,0)
aStrOrig := NIL 

Return aFields





/*/{Protheus.doc} A103QryNF
//TODO seleciona os registros de acordo com os parâmetros informados na função A103FRet().
@author reynaldo
@since 04/06/2018
@version 1.0
@return ${return}, ${return_description}
@param lDocVincul, logical, descricao
@param cCliente, characters, descricao
@param cLoja, characters, descricao
@param dDataDe, date, descricao
@param dDataAte, date, descricao
@param lFilCliFor, logical, descricao
@param lAllCliFor, logical, descricao
@type function
/*/
Static Function A103QryNF(lDocVincul, cCliente, cLoja, dDataDe, dDataAte, lFilCliFor, lAllCliFor, lFlagDev)

Local cAliasSF2 := 'SF2'
Local cFieldQry := ""
Local nCnt		:= 0
Local aStruct	:= {}

Default lFlagDev := .F.

cAliasSF2 := GetNextAlias()
If lDocVincul

	cQuery := " SELECT DISTINCT SDH.DH_FILIAL ,SDH.DH_SERIE ,SDH.DH_DOC ,SDH.DH_CLIENTE ,SDH.DH_LOJACLI ,SDH.DH_FORNECE ,SDH.DH_LOJAFOR ,SDH.DH_DTDIGIT ,D2_DOC F2_DOC ,D2_SERIE F2_SERIE "
	cQuery += " FROM " + RetSqlName("SDH") + " SDH "
	cQuery += " INNER JOIN " + RetSqlName("SD2") + " SD2 ON SD2.D2_FILIAL = '" + xFilial("SD2") + "' "
	cQuery += " AND SD2.D2_NUMSEQ = SDH.DH_IDENTNF "
	cQuery += " AND SD2.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE SDH.DH_FILIAL  = '" + xFilial("SDH") + "' "
	cQuery += 		" AND SDH.DH_OPER = '2' "
	cQuery += 		" AND SDH.DH_TPMOV = '2' "
	If lAllCliFor
		cQuery += 		" AND SDH.DH_CLIENTE = '" + cCliente + "' "
		cQuery += 		" AND SDH.DH_LOJACLI = '" + cLoja    + "' "
	Else
		cQuery += 		" AND SDH.DH_FORNECE = '" + cCliente + "' "
		cQuery += 		" AND SDH.DH_LOJAFOR = '" + cLoja    + "' "
	EndIf
	cQuery += 		" AND SDH.DH_DTDIGIT BETWEEN '" + DtoS(dDataDe) + "' AND '" + DtoS(dDataAte) + "' "
	cQuery += 		" AND SDH.D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY SDH.DH_FILIAL, SDH.DH_DOC, SDH.DH_SERIE "

Else
	aStruct := SF2->(dbStruct())
	For nCnt := 1 To Len(aStruct)
		cFieldQry += IIF(Len(cFieldQry)>0 ," ," ,"")
		cFieldQry += aStruct[nCnt,1] 
	Next nCnt
	
	If ExistBlock("MT103DEV")//Ponto de entrada para substituir a query original
		cQuery := ExecBlock("MT103DEV",.F.,.F.,{dDataDe,dDataAte, cCliente, cLoja, cFieldQry})
	Else
		cQuery := " SELECT " + cFieldQry + " "
		cQuery += " FROM " + RetSqlName("SF2") + " "
		cQuery += " WHERE F2_FILIAL  = '" + xFilial("SF2") + "' "
		If !Empty(cCliente)
			cQuery += 	" AND F2_CLIENTE = '" + cCliente + "' "
			cQuery += 	" AND F2_LOJA = '" + cLoja + "' "
		EndIf
		If !Empty(dDataDe) .And. !Empty(dDataAte)
			cQuery += 	" AND F2_EMISSAO BETWEEN '" + DtoS(dDataDe) + "' AND '" + DtoS(dDataAte) + "' "
		EndIf
		cQuery += 		" AND F2_TIPO NOT IN ('D'"
		If !lAllCliFor
			If lFilCliFor
				cQuery += ",'B') "
			Else
				cQuery += ",'N') "
			EndIf
		Else
			cQuery += ") "
		EndIf
		If lFlagDev
			cQuery += " AND F2_FLAGDEV <> '1' "
		EndIf
		cQuery += 	" AND D_E_L_E_T_ = ' ' "
	EndIf
EndIf
cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSF2,.T.,.T.)

aStruct := SF2->(dbStruct())
For nCnt := 1 To Len(aStruct)
	If aStruct[nCnt][2] <> "C"
		TcSetField(cAliasSF2 ,aStruct[nCnt, 1] ,aStruct[nCnt, 2] ,aStruct[nCnt, 3] ,aStruct[nCnt, 4])
	EndIf
Next nX

aStruct := SDH->(dbStruct())
For nCnt := 1 To Len(aStruct)
	If aStruct[nCnt][2] <> "C"
		TcSetField(cAliasSF2 ,aStruct[nCnt, 1] ,aStruct[nCnt, 2] ,aStruct[nCnt, 3] ,aStruct[nCnt, 4])
	EndIf
Next nX

If Select(cAliasSF2)<=0
	cAliasSF2 := ""
EndIf

Return cAliasSF2


/*/{Protheus.doc} A103DFldQ
//TODO define a estrutura da tabela temporia baseado na query com os registros selecionados
@author reynaldo
@since 04/06/2018
@version 1.0
@return ${return}, ${return_description}
@param cAliasTRB, characters, descricao
@type function
/*/
Static Function A103DFldQ(cAliasTRB)
Local aStruField:= {}
Local aStruTMP	:= {}
Local nCnt		:= 0

	aAdd(aStruTMP,{"TRB_OK","C",01,00})
	
	aStruct := (cAliasTRB)->(dbStruct())
	For nCnt := 1 To Len(aStruct)
		aStruField := aStruct[nCnt]
		aAdd(aStruTMP, aStruField)
	Next nCnt
	
Return aStruTMP


/*/{Protheus.doc} A103DIdxQ
//TODO define os indices basesado nas tabelas utilizadas na seleção dos registros 
@author reynaldo
@since 04/06/2018
@version 1.0
@return ${return}, ${return_description}
@param lCliente, logical, descricao
@param lDocVincul, logical, descricao
@type function
/*/
Static Function A103DIdxQ(lCliente, lDocVincul)
Local cAliasTRB := ""
Local nCnt		:= 0
Local nI		:= 1
Local aIdxTMP	:= {}
Local aIdxAux	:= {}
Local sTMP		:= ""
Local aTMP		:= {}
Local cDescric	:= ""
Local aFwIdx	:= FWFormStruct(1,'SF2'):aindex

Local cFilds	:= ""
	If lCliente
		aIdxTMP := {}
	Else
		If lDocVincul
			cAliasTRB := "SDH"
			aTMP := {"DH_FILIAL" ,"DH_SERIE" ,"DH_DOC" ,"DH_CLIENTE" ,"DH_LOJACLI" ,"DH_FORNECE" ,"DH_LOJAFOR" ,"DH_DTDIGIT"}
			For nCnt := 1 to len(aTmp)
				cDescric += RetTitle(aTmp[nCnt])
			Next nCnt
			aAdd(aIdxTMP ,{cDescric ,aTMP})
		Else
			For nI := 1 to len(aFwIdx)
				if ascan(aFwIdx,{|x| substr(x[3],1,len(alltrim(aFwIdx[ni][3])))== alltrim((aFwIdx[ni][3])).and. x[3] <> aFwIdx[ni][3] }) == 0 // impede inclusão de para indices parcialmente igual.
						sTMP := aFwIdx[ni][3]
						aTMP := StrTokArr(sTMP ,"+")
						cFilds := ""  
					For nCnt := 1 to len(aTMP)
						aTMP[nCnt] := Alltrim(STRTRAN(aTMP[nCnt] ,"DTOS" ,""))
						aTMP[nCnt] := Alltrim(STRTRAN(aTMP[nCnt] ,"(" ,""))
						aTMP[nCnt] := Alltrim(STRTRAN(aTMP[nCnt] ,")" ,""))
					Next nCnt 
						
				aAdd(aIdxTMP ,{IIF("F2_FILIAL" $ aFwIdx[ni][3],iif(UPPER("STR0520")+"+" $ Upper(StrTran(aFwIdx[ni][4]," ", "")) ,aFwIdx[ni][4],"STR0520"+" + "+aFwIdx[ni][4]),aFwIdx[ni][4]) ,aTMP})
				
				endif
			next
		EndIf
	EndIf
Return aIdxTMP


/*/{Protheus.doc} A103NewTMP
//TODO cria a tabela temporaria, conforme parametros informados
@author reynaldo
@since 04/06/2018
@version 1.0
@return ${return}, ${return_description}
@param oTmpTable, object, descricao
@param aStrTMP, array, descricao
@param aIdxTMP, array, descricao
@type function
/*/
Static Function A103NewTMP(oTmpTable ,aStrTMP ,aIdxTMP)
Local cAliasTRB := GetNextAlias()
Local nCnt 		:= 0

	// crio a tabela temporaria
	oTmpTable := FWTemporaryTable():New(cAliasTRB)
	oTmpTable:SetFields( aStrTMP ) 
	For nCnt := 1 to Len(aIdxTMP)
		oTmpTable:AddIndex("IDX"+STRZERO(nCnt,2),aIdxTMP[nCnt ,2]) 
	Next nCnt
	oTmpTable:Create() 
	If Select(cAliasTRB) <= 0
		cAliasTRB := ""
	EndIf
	
Return cAliasTRB


/*/{Protheus.doc} A103InsTMP
//TODO insire os registros da Query na tabela temporaria
@author reynaldo
@since 04/06/2018
@version 1.0
@return ${return}, ${return_description}
@param cAliasQRY, characters, descricao
@param aStrQRY, array, descricao
@param cAliasTMP, characters, descricao
@param aStrTMP, array, descricao
@type function
/*/
Static Function A103InsTMP(cAliasQRY,aStrQRY, cAliasTMP,aStrTMP)
Local nFieldPos := 0
Local nCnt		:= 0
Local uConteudo	:= NIL

	While (cAliasQRY)->(!Eof())
		Reclock(cAliasTMP,.T.)
		For nCnt := 1 To len(aStrTMP)
			nFieldPos := aScan(aStrQRY,{|x|x[1] == aStrTMP[nCnt,1]})
			If nFieldPos >0
				nFieldPos := (cAliasQRY)->(FieldPos(aStrQRY[nCnt,1]))
				If nFieldPos > 0
					uConteudo := (cAliasQRY)->(FieldGet(nFieldPos))
					(cAliasTMP)->(FieldPut(nCnt ,uConteudo))
				EndIf
			EndIf
		Next nCnt
		MsUnLock()
	
		(cAliasQRY)->(dbSkip())
	EndDo

Return 


/*/{Protheus.doc} MontColMb
//TODO Monta um array com a estrutura necessária para as colunas da markbrowse 
baseada nos campos a serem apresentadas com a estrutura da tabela a ser utilizada.
@author reynaldo
@since 04/06/2018
@version 1.0
@return ${return}, ${return_description}
@param aFieldView, array, descricao
@param aStrTMP, array, descricao
@type function
/*/
Static Function MontColMb(aFieldView,aStrTMP)
Local nCnt		:= 0
Local nPos		:= 0
Local aColsMB	:= {}

	For nCnt := 1 to Len(aFieldView)
		nPos := aScan(aStrTMP,{|x|x[1]==aFieldView[nCnt]})
		If nPos >0
			aAdd( aColsMB, {})
			aAdd( aColsMB[Len(aColsMB)] ,aStrTMP[nPos ,1])
			aAdd( aColsMB[Len(aColsMB)] ,RetTitle(aStrTMP[nPos ,1]))
			aAdd( aColsMB[Len(aColsMB)] ,aStrTMP[nPos ,2])
			aAdd( aColsMB[Len(aColsMB)] ,aStrTMP[nPos ,3])
			aAdd( aColsMB[Len(aColsMB)] ,aStrTMP[nPos ,4])
			aAdd( aColsMB[Len(aColsMB)] ,x3Picture(aStrTMP[nPos ,1]))
		EndIf
	Next nCnt

Return aColsMB


/*/{Protheus.doc} MontIdxMb
//TODO monta um array com a estrutura necessária para os índices da markbrowse baseada 
nos campos dos índices a serem apresentadas com a estrutura da tabela a ser utilizada.
@author reynaldo
@since 04/06/2018
@version 1.0
@return ${return}, ${return_description}
@param aIdxTMP, array, descricao
@param aStrTMP, array, descricao
@type function
/*/
Static Function MontIdxMb(aIdxTMP,aStrTMP)
Local nCnt		:= 0
Local nCnt1		:= 0
Local nPos		:= 0
Local aIdxMB	:= {}
Local aField	:= {}

	For nCnt := 1 to Len(aIdxTMP)
		aAdd( aIdxMB, {})
		aAdd( aIdxMB[Len(aIdxMB)] ,aIdxTMP[nCnt,1]) // composicao do indice com os titulos
		aField := {}
		For nCnt1 := 1 to Len(aIdxTMP[nCnt ,2])
			nPos := aScan(aStrTMP,{|x|x[1]==aIdxTMP[nCnt ,2 ,nCnt1]})
			If nPos >0
				aAdd( aField, {})

				aAdd( aField[Len(aField)] ,"")
				aAdd( aField[Len(aField)] ,aStrTMP[nPos ,2])
				aAdd( aField[Len(aField)] ,aStrTMP[nPos ,3])
				aAdd( aField[Len(aField)] ,aStrTMP[nPos ,4])
				aAdd( aField[Len(aField)] ,RetTitle(aStrTMP[nPos ,1]))
				aAdd( aField[Len(aField)] ,x3Picture(aStrTMP[nPos ,1]))
				
			EndIf
		Next nCnt1
		aAdd( aIdxMB[Len(aIdxMB)] ,aField)
	Next nCnt

Return aIdxMB





/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³U_A103PcDvºAutor  ³Henry Fila          º Data ³  06/29/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Abre a tela da nota fiscal de entrada de acordo com a nota º±±
±±º          ³ de saida escolhida no browse                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
±±³          ³ ExpN2 = Numero da opcao selecionada                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function A103PcDv(cAlias,nReg,nOpcx,lCliente,cCliente,cLoja,cDocSF2,lFlagDev)

Local aArea     := GetArea()
Local aAreaSF2  := SF2->(GetArea())
Local aCab      := {}
Local aLinha    := {}
Local aItens    := {}
Local cTipoNF   := ""
Local lDevolucao:= .T.
Local lPoder3   := .T.
Local cIndex	:= ""
Local lRestDev	:= .T.
Local nPFreteI  := 0
Local nPFreteC  := 0
Local nPSegurI  := 0
Local nPSegurC  := 0
Local nPDespI   := 0
Local nPDespC   := 0
Local nX        := 0
Local cMvNFEAval :=	GetNewPar( "MV_NFEAFSD", "000" )
Local nHpP3     := 0
Local lHelpTES  := .T.
Local cEspecie	:= "NF"

Default lCliente := .F.
Default cCliente := SF2->F2_CLIENTE
Default cLoja    := SF2->F2_LOJA
Default cDocSF2  := ''
Default	cQrDvF2  := ''
Default lFlagDev := .F.

If Type("cTipo") == "U"
	PRIVATE cTipo:= ""
EndIf

If Empty(cQrDvF2)
	cQrDvF2 := "F2_FILIAL == '" + xFilial("SF2") + "' "
	cQrDvF2 += ".AND. F2_TIPO <> 'D' "
Endif

If !SF2->(Eof())

	lDevolucao := M103FilDv(@aLinha,@aItens,cDocSF2,cCliente,cLoja,lCliente,@cTipoNF,@lPoder3,,@nHpP3,@lHelpTES,@cEspecie)

	If lDevolucao .and. Len(aItens)>0
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Montagem do Cabecalho da Nota fiscal de Devolucao/Retorno       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AAdd( aCab, { "F1_DOC"    , Z10->Z10_NUMNFE			, Nil } )	// Numero da NF : Obrigatorio
		AAdd( aCab, { "F1_SERIE"  , Z10->Z10_SERIE			, Nil } )	// Serie da NF  : Obrigatorio
		AAdd( aCab, { "F1_CHVNFE"  , Z10->Z10_CHVNFE		, Nil } )	// Chave da NF  : Obrigatorio

		If !lPoder3
			AAdd( aCab, { "F1_TIPO"   , "D"                  		, Nil } )	// Tipo da NF   : Obrigatorio
		Else
			AAdd( aCab, { "F1_TIPO"   , IIF(cTipoNF=="B","N","B")	, Nil } )	// Tipo da NF   : Obrigatorio
		EndIf

		AAdd( aCab, { "F1_FORNECE", cCliente    				, Nil } )	// Codigo do Fornecedor : Obrigatorio
		AAdd( aCab, { "F1_LOJA"   , cLoja    	   		   	    , Nil } )	// Loja do Fornecedor   : Obrigatorio
		AAdd( aCab, { "F1_EMISSAO", dDataBase           		, Nil } )	// Emissao da NF        : Obrigatorio
		AAdd( aCab, { "F1_FORMUL" , "N"                 		, Nil } )  // Formulario


		AAdd( aCab, { "F1_ESPECIE", If(Empty(CriaVar("F1_ESPECIE",.T.)) .And. !ExistBlock("MT103ESP"),; 
			PadR(cEspecie,Len(SF1->F1_ESPECIE)),CriaVar("F1_ESPECIE",.T.)), Nil } )  // Especie
		AAdd( aCab, { "F1_FRETE",0,Nil})
		AAdd( aCab, { "F1_SEGURO",0,Nil})
		AAdd( aCab, { "F1_DESPESA",0,Nil})

    	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Agrega o Frete/Desp/Seguro  referente a NF Retornada  ³
		//| de acordo com o parametro MV_NFEAFSD 				  ³
		//ÀÄÄÄÄ--ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nPFreteC := aScan(aCab,{|x| AllTrim(x[1])=="F1_FRETE"})
		nPFreteI := aScan(aItens[1],{|x| AllTrim(x[1])=="D1_VALFRE"})
   		nPSegurC := aScan(aCab,{|x| AllTrim(x[1])=="F1_SEGURO"})
		nPSegurI := aScan(aItens[1],{|x| AllTrim(x[1])=="D1_SEGURO"})
   		nPDespC := aScan(aCab,{|x| AllTrim(x[1])=="F1_DESPESA"})
		nPDespI := aScan(aItens[1],{|x| AllTrim(x[1])=="D1_DESPESA"})

		For nX = 1 to Len(aItens)
		    If len(cMvNFEAval)>=1
		        If Substr(cMvNFEAval,1,1)=="1"
  		   			aCab[nPFreteC][2] := aCab[nPFreteC][2] + aItens[nX][nPFreteI][2]
  		  	    EndIf
  		  	EndIf
  		  	If len(cMvNFEAval)>=2
		        If Substr(cMvNFEAval,2,1)=="1"
  		    		aCab[nPSegurC][2] := aCab[nPSegurC][2] + aItens[nX][nPSegurI][2]
  		  	    EndIf
  		  	EndIf
   		  	If len(cMvNFEAval)=3
		        If Substr(cMvNFEAval,3,1)=="1"
  		    		aCab[nPDespC][2] := aCab[nPDespC][2] + aItens[nX][nPDespI][2]
  		  	    EndIf
  		  	EndIf
		Next nX

		Mata103( aCab, aItens , 3 , .T.)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se nao ha mais saldo para devolucao³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cPaisLoc == "BRA" .And. lFlagDev
			lRestDev := M103FilDv(@aLinha,@aItens,cDocSF2,cCliente,cLoja,lCliente,@cTipoNF,@lPoder3,.F.)
			If !lRestDev
				RecLock("SF2",.F.)
				SF2->F2_FLAGDEV := "1"
				MsUnLock()
			Endif
		Endif
	Else
		
		If lHelpTES .And. !lDevolucao .And. !lPoder3 .AND. lAtivo
			Help(" ", 1, "TESPOD3")
		EndIf
		/*
		nHpP3 = Situacao 0 -> Mostra a mensagem
		nHpP3 = Situacao 1 -> Nao mostra a mensagem
		*/
		If (nHpP3 == 0) .And. lPoder3
			Help(" ",1,"NFDGSPTZ")	//Nota Fiscal de Devolução já gerada ou o saldo devedor em poder de terceiro está zerado.
		EndIf
	EndIf

	MsUnLockAll()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Refaz o filtro quando a selecao e por documento, visto que a tela com os³
	//³documentos que podem ser devolvidos e montada novamente.                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !lCliente
		DbSelectArea("SF2")
		SF2->(dbSetOrder(1))
		cIndex := CriaTrab(NIL,.F.)
		IndRegua("SF2",cIndex,SF2->(IndexKey()),,cQrDvF2)
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a entrada da rotina                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestArea(aAreaSF2)
RestArea(aArea)
Return(.T.)



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M103FilDv ºAutor  ³Mary C. Hergert     º Data ³19/03/2008   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica os itens que podem ser devolvidos do documento    º±±
±±º          ³ selecionado.                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Parametros³ ExpA1 = Linhas com os itens de devoluvao                   ³±±
±±³          ³ ExpA2 = Itens de devolucao                                 ³±±
±±³          ³ ExpC3 = Documentos do SF2 a serem processados              ³±±
±±³          ³ ExpC4 = Cliente do filtro                                  ³±±
±±³          ³ ExpC5 = Loja do cliente do filtro                          ³±±
±±³          ³ ExpL6 = Se a tela e por cliente/fornecedor                 ³±±
±±³          ³ ExpL7 = Tipo do documento - normal, devolucao, benefic.    ³±±
±±³          ³ ExpL8 = Se tem controle de terceiros no estoque            ³±±
±±³          ³ ExpL9 =                                                    ³±±
±±³          ³ ExpL10 = Ativa mensagem de poder de terceiros              ³±±
±±³          ³ ExpL10                                                     ³±±
±±³          ³ ExpC12 = Especie Padrão Utilizada no Documento             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function M103FilDv(aLinha,aItens,cDocSF2,cCliente,cLoja,lCliente,cTipoNF,lPoder3,lHelp,nHpP3,lHelpTES,cEspecie)

Local aAreaAnt  := {}
Local aSaldoTerc:= {}
Local aStruSD2  := {}
Local cFilSX5   := xFilial("SX5")
Local cAliasSF4 := ""
Local cAliasSD2 := ""
Local cCfop     := ""
Local cNFORI  	:= ""
Local cSERIORI	:= ""
Local cITEMORI	:= ""
Local cNewDSF2	:= ""
Local cDSF2Aux	:= ""
Local cQuery    := ""
Local cAliasCpl := ""
Local nTpCtlBN  := A410CtEmpBN()
Local nSldDev   := 0
Local nSldDevAux:= 0
Local nDesc     := 0
Local nTotal	:= 0
Local nVlCompl  := 0
Local nPosDiv	:= 0
Local nX		:= 0
Local lMt103FDV := ExistBlock("MT103FDV")
Local lCompl    := SuperGetMv("MV_RTCOMPL",.F.,"S") == "S"
Local lDevolucao:= .T.
Local lDevCode	:= .F.
Local lTravou	:= .F.
Local lExit		:= .F.

Default lHelp    := .T.
Default lHelpTES := .T.

If !Empty(cDocSF2)												// Selecao foi feita por "Cliente/Fornecedor"

	cNewDSF2 := StrTran(StrTran(cDocSF2,"('",),"')",)			// Retira parêteses e aspas da string do documento, caso houver

	nPosDiv := At("','",cNewDSF2)								// String ',' identifica que foi selecionada mais de uma nota de saida
	If nPosDiv == 0												// Se foi selecionada apenas uma nota de saida
		DbSelectArea("SF2")
		DbSetOrder(1)
		If MsSeek(xFilial("SF2")+cNewDSF2+cCliente+cLoja)
			lTravou := SoftLock("SF2")							// Tenta reservar o registro para prosseguir com o processo
		Else
			dbGoTop()
		EndIf
	Else														// Se foi selecionada mais de uma nota de saida
		cDSF2Aux := cNewDSF2
		For nX := 1 to Len(cDSF2Aux)
			nPosDiv := At("','",cDSF2Aux)
			If nPosDiv > 0
				cNewDSF2 := SubStr(cDSF2Aux,1,(nPosDiv-1))		// Extrai a primeira nota/serie da string
				cDSF2Aux := SubStr(cDSF2Aux,(nPosDiv+3),Len(cDSF2Aux)) // Grava nova string sem a primeira nota/serie
			Else
				cNewDSF2 := cDSF2Aux
				lExit := .T.
			EndIf
			If !Empty(cNewDSF2)
				DbSelectArea("SF2")
				DbSetOrder(1)
				If MsSeek(xFilial("SF2")+cNewDSF2+cCliente+cLoja)
					lTravou := SoftLock("SF2")					// Tenta reservar todos os registros para prosseguir com o processo
				Else
					dbGoTop()
				EndIf
			EndIf
			If lExit
				Exit
			EndIf
		Next nX
	EndIf
Else
	lTravou := SoftLock("SF2")
EndIf

If lTravou

	If !Empty(SF2->F2_ESPECIE)
		cEspecie := SF2->F2_ESPECIE
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem dos itens da Nota Fiscal de Devolucao/Retorno          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SD2")
	DbSetOrder(3)

	cAliasSD2 := "Oms320Dev"
	cAliasSF4 := "Oms320Dev"
	aStruSD2  := SD2->(dbStruct())
	cQuery    := "SELECT SF4.F4_CODIGO, SF4.F4_CF, SF4.F4_PODER3, SF4.F4_QTDZERO, SF4.F4_ATUATF, SF4.F4_ESTOQUE, SD2.*, "
	cQuery    += " SD2.R_E_C_N_O_ SD2RECNO "
	cQuery    += " FROM "+RetSqlName("SD2")+" SD2,"
	cQuery    += RetSqlName("SF4")+" SF4 "
	cQuery    += " WHERE SD2.D2_FILIAL='"+xFilial("SD2")+"' AND "
	If !lCliente
		cQuery    += "SD2.D2_DOC   = '"+SF2->F2_DOC+"' AND "
		cQuery    += "SD2.D2_SERIE = '"+SF2->F2_SERIE+"' AND "
	Else
		If !Empty(cDocSF2)
			If UPPER(Alltrim(TCGetDb()))=="POSTGRES"
				cQuery += " Concat(D2_DOC,D2_SERIE) IN "+cDocSF2+" AND "
			Else
				cQuery += " D2_DOC||D2_SERIE IN "+cDocSF2+" AND "
			EndIf
		EndIf
	EndIf
	cQuery    += " SD2.D2_CLIENTE   = '"+cCliente+"' AND "
	cQuery    += " SD2.D2_LOJA      = '"+cLoja+"' AND "
	cQuery    += " ((SD2.D2_QTDEDEV < SD2.D2_QUANT) OR "
	cQuery    += " (SD2.D2_VALDEV  = 0) OR "
	cQuery    += " (SF4.F4_QTDZERO = '1' AND SD2.D2_VALDEV < SD2.D2_TOTAL)) AND "
	cQuery    += " SD2.D_E_L_E_T_  = ' ' AND "
	cQuery    += " SF4.F4_FILIAL   = '"+xFilial("SF4")+"' AND "
	cQuery    += " SF4.F4_CODIGO   = (SELECT F4_TESDV FROM "+RetSqlName("SF4")+" WHERE "
	cQuery    += " F4_FILIAL	   = '"+xFilial("SF4")+"' AND "
	cQuery    += " F4_CODIGO	   = SD2.D2_TES AND "
	cQuery    += " D_E_L_E_T_	   = ' ' ) AND "
	cQuery    += " SF4.D_E_L_E_T_  = ' ' "
	cQuery    += " ORDER BY "+SqlOrder(SD2->(IndexKey()))

	cQuery    := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD2,.T.,.T.)

	For nX := 1 To Len(aStruSD2)
		If aStruSD2[nX][2]<>"C"
			TcSetField(cAliasSD2,aStruSD2[nX][1],aStruSD2[nX][2],aStruSD2[nX][3],aStruSD2[nX][4])
		EndIf
	Next nX

	If Eof()
		If lHelp
			Help(" ",1,"DSNOTESDT")
			nHpP3 := 1
		EndIf
		lDevolucao := .F.
		lHelpTES   := .F.
	EndIf

	While !Eof() .And. (cAliasSD2)->D2_FILIAL == xFilial("SD2") .And.;
			(cAliasSD2)->D2_CLIENTE 		   == cCliente 		  .And.;
			(cAliasSD2)->D2_LOJA			   == cLoja 		  .And.;
			If(!lCliente,(cAliasSD2)->D2_DOC  == SF2->F2_DOC     .And.;
			(cAliasSD2)->D2_SERIE			   == SF2->F2_SERIE,.T.)

		If ((cAliasSD2)->D2_QTDEDEV < (cAliasSD2)->D2_QUANT) .Or. ((cAliasSD2)->D2_VALDEV == 0) .Or. ((cAliasSD2)->F4_QTDZERO == "1" .And. (cAliasSD2)->D2_VALDEV < (cAliasSD2)->D2_TOTAL)

			If (cAliasSD2)->F4_PODER3<>"D"
				lPoder3 := .F.
			EndIf
			If lPoder3 .And. !cTipo$"B|N"
				cTipo := IIF(cTipoNF=="B","N","B")
			ElseIf !cTipo$"B|N"
				cTipo := "D"
			EndIf
			If (cAliasSD2)->F4_ATUATF = "S" .AND. cTipo$"B|D"
				lAtivo     := .F.
				Exit
			Endif

			If !lMt103FDV .Or. ExecBlock("MT103FDV",.F.,.F.,{cAliasSD2})
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Destroi o Array, o mesmo é carregado novamente pela CalcTerc    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If Len(aSaldoTerc)>0
					aSize(aSaldoTerc,0)
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Calcula o Saldo a devolver                                      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cTipoNF := (cAliasSD2)->D2_TIPO

				Do Case
					Case (cAliasSF4)->F4_PODER3=="D"
						aSaldoTerc := CalcTerc((cAliasSD2)->D2_COD,(cAliasSD2)->D2_CLIENTE,(cAliasSD2)->D2_LOJA,(cAliasSD2)->D2_IDENTB6,(cAliasSD2)->D2_TES,cTipoNF)
						nSldDev :=iif(Len(aSaldoTerc)>0,aSaldoTerc[1],0)
					Case cTipoNF == "N"
						nSldDev := (cAliasSD2)->D2_QUANT-(cAliasSD2)->D2_QTDEDEV
					Case cTipoNF == "B" .And.(cAliasSF4)->F4_PODER3 =="N" .And. A103DevPdr((cAliasSF4)->F4_CODIGO)
						nSldDev := (cAliasSD2)->D2_QUANT-(cAliasSD2)->D2_QTDEDEV
						lPoder3 := .T.
					OtherWise
						nSldDev := 0
				EndCase

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Efetua a montagem da Linha                                      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

				If nSldDev > 0 .Or. (cTipoNF$"CIP" .And. (cAliasSD2)->D2_VALDEV == 0) .Or.;
				   ( (cAliasSD2)->D2_QUANT == 0 .And. (cAliasSD2)->D2_VALDEV == 0 .And. (cAliasSD2)->D2_TOTAL > 0 ) .Or.;
					( (cAliasSD2)->F4_QTDZERO == "1" .And. (cAliasSD2)->D2_VALDEV < (cAliasSD2)->D2_TOTAL )

					lDevCode := .T.

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se deve considerar o preco das notas de complemento    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lCompl
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica se existe nota de complemento de preco                 ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						aAreaAnt  := GetArea()
						cAliasCpl := GetNextAlias()
						cQuery    := "SELECT SUM(SD2.D2_PRCVEN) AS D2_PRCVEN "
						cQuery    += "  FROM "+RetSqlName("SD2")+" SD2 "
						cQuery    += " WHERE SD2.D2_FILIAL  = '"+xFilial("SD2")+"'"
						cQuery    += "   AND SD2.D2_TIPO    = 'C' "
						cQuery    += "   AND SD2.D2_NFORI   = '"+SF2->F2_DOC+"'"
						cQuery    += "   AND SD2.D2_SERIORI = '"+SF2->F2_SERIE+"'"
						cQuery    += "   AND SD2.D2_ITEMORI = '"+(cAliasSD2)->D2_ITEM +"'"
						cQuery    += "   AND ((SD2.D2_QTDEDEV < SD2.D2_QUANT) OR "
						cQuery    += "       (SD2.D2_VALDEV = 0))"
						cQuery    += "   AND SD2.D2_TES         = '"+(cAliasSD2)->D2_TES+"'"
						cQuery    += "   AND SD2.D_E_L_E_T_     = ' ' "

						cQuery    := ChangeQuery(cQuery)
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasCpl,.T.,.T.)

						TcSetField(cAliasCpl,"D2_PRCVEN","N",TamSX3("D2_PRCVEN")[1],TamSX3("D2_PRCVEN")[2])

						If !(cAliasCpl)->(Eof())
							nVlCompl := (cAliasCpl)->D2_PRCVEN
						Else
							nVlCompl := 0
						EndIf

						(cAliasCpl)->(dbCloseArea())
						RestArea(aAreaAnt)
					EndIf

					aLinha := {}
					nDesc  := 0
	  				AAdd( aLinha, { "D1_COD"    , (cAliasSD2)->D2_COD    , Nil } )
					AAdd( aLinha, { "D1_QUANT"  , nSldDev, Nil } )
					If (cAliasSD2)->D2_QUANT==nSldDev
						If Len(aSaldoTerc)=0   // Nf sem Controle Poder Terceiros
							If ((cAliasSD2)->F4_QTDZERO == "1" .And. (cAliasSD2)->D2_VALDEV < (cAliasSD2)->D2_TOTAL)
								AAdd( aLinha, { "D1_VUNIT"  , ((cAliasSD2)->D2_PRCVEN - (cAliasSD2)->D2_VALDEV), Nil })
							ElseIf (cAliasSD2)->D2_DESCON+(cAliasSD2)->D2_DESCZFR == 0
							   	AAdd( aLinha, { "D1_VUNIT"  , (cAliasSD2)->D2_PRCVEN, Nil })
							Else
							    nDesc:=(cAliasSD2)->D2_DESCON+(cAliasSD2)->D2_DESCZFR
								AAdd( aLinha, { "D1_VUNIT"  , ((cAliasSD2)->D2_TOTAL+nDesc)/(cAliasSD2)->D2_QUANT, Nil })
							EndIf
						Else                   // Nf com Controle Poder Terceiros
							If (cAliasSD2)->D2_DESCON+(cAliasSD2)->D2_DESCZFR == 0
								AAdd( aLinha, { "D1_VUNIT"  , NoRound((aSaldoTerc[5]-aSaldoTerc[4])/nSldDev,TamSX3("D2_PRCVEN")[2]), Nil })
							Else
							    nDesc:=(cAliasSD2)->D2_DESCON+(cAliasSD2)->D2_DESCZFR
							    nDesc:=iif(nDesc>0,(nDesc/aSaldoTerc[6])*nSldDev,0)
								AAdd( aLinha, { "D1_VUNIT"  , NoRound(((aSaldoTerc[5]+nDesc)-aSaldoTerc[4])/nSldDev,TamSX3("D2_PRCVEN")[2]), Nil })
							EndIf
						EndIf
						nTotal:= A410Arred(aLinha[2][2]*aLinha[3][2],"D1_TOTAL")
						If nTotal == 0 .And. (cAliasSD2)->D2_QUANT == 0 .And. (cAliasSD2)->D2_PRCVEN == (cAliasSD2)->D2_TOTAL
							If (cAliasSD2)->F4_QTDZERO == "1"
								nTotal := (cAliasSD2)->D2_TOTAL - (cAliasSD2)->D2_VALDEV
							Else
								nTotal := (cAliasSD2)->D2_TOTAL
							EndIf
						EndIf
	 					AAdd( aLinha, { "D1_TOTAL"  , nTotal,Nil } )
						AAdd( aLinha, { "D1_VALDESC", nDesc , Nil } )
						AAdd( aLinha, { "D1_VALFRE", (cAliasSD2)->D2_VALFRE, Nil } )
						AAdd( aLinha, { "D1_SEGURO", (cAliasSD2)->D2_SEGURO, Nil } )
						AAdd( aLinha, { "D1_DESPESA", (cAliasSD2)->D2_DESPESA, Nil } )
					Else
						nSldDevAux:= (cAliasSD2)->D2_QUANT-(cAliasSD2)->D2_QTDEDEV
						If Len(aSaldoTerc)=0	// Nf sem Controle Poder Terceiros
						    nDesc:=(cAliasSD2)->D2_DESCON+(cAliasSD2)->D2_DESCZFR
						    nDesc:=iif(nDesc>0,(nDesc/(cAliasSD2)->D2_QUANT)*IIf(nSldDevAux==0,1,nSldDevAux),0)
						    AAdd( aLinha, { "D1_VUNIT"  ,((((cAliasSD2)->D2_TOTAL+(cAliasSD2)->D2_DESCON+(cAliasSD2)->D2_DESCZFR))-(cAliasSD2)->D2_VALDEV)/IIf(nSldDevAux==0,1,nSldDevAux), Nil })
					    Else  					// Nf com Controle Poder Terceiros
						    nDesc:=(cAliasSD2)->D2_DESCON+(cAliasSD2)->D2_DESCZFR
						    nDesc:=iif(nDesc>0,(nDesc/aSaldoTerc[6])*nSldDev,0)
							AAdd( aLinha, { "D1_VUNIT"  , NoRound(((aSaldoTerc[5]+nDesc)-aSaldoTerc[4])/nSldDev,TamSX3("D2_PRCVEN")[2]), Nil })
					    EndIf

	 					AAdd( aLinha, { "D1_TOTAL"  , A410Arred(aLinha[2][2]*aLinha[3][2],"D1_TOTAL"),Nil } )
						AAdd( aLinha, { "D1_VALDESC", nDesc , Nil } )
						AAdd( aLinha, { "D1_VALFRE" , A410Arred(((cAliasSD2)->D2_VALFRE/(cAliasSD2)->D2_QUANT)*nSldDev,"D1_VALFRE"),Nil } )
						AAdd( aLinha, { "D1_SEGURO" , A410Arred(((cAliasSD2)->D2_SEGURO/(cAliasSD2)->D2_QUANT)*nSldDev,"D1_SEGURO"),Nil } )
						AAdd( aLinha, { "D1_DESPESA" , A410Arred(((cAliasSD2)->D2_DESPESA/(cAliasSD2)->D2_QUANT)*nSldDev,"D1_DESPESA"),Nil } )
					EndIf
					AAdd( aLinha, { "D1_IPI"    , (cAliasSD2)->D2_IPI    , Nil } )
					AAdd( aLinha, { "D1_LOCAL"  , (cAliasSD2)->D2_LOCAL  , Nil } )
					AAdd( aLinha, { "D1_TES" 	, (cAliasSF4)->F4_CODIGO , Nil } )
					If ("000"$AllTrim((cAliasSF4)->F4_CF) .Or. "999"$AllTrim((cAliasSF4)->F4_CF))
						cCfop := AllTrim((cAliasSF4)->F4_CF)
					Else
                        cCfop := SubStr("123",At(SubStr((cAliasSD2)->D2_CF,1,1),"567"),1)+SubStr((cAliasSD2)->D2_CF,2)
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica se existe CFOP equivalente considerando a CFOP do documento de saida  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						SX5->( dbSetOrder(1) )
						If !SX5->(MsSeek( cFilSX5 + "13" + cCfop ))
							cCfop := AllTrim((cAliasSF4)->F4_CF)
						EndIf
					EndIf
					AAdd( aLinha, { "D1_CF"		, cCfop, Nil } )
					AAdd( aLinha, { "D1_UM"     , (cAliasSD2)->D2_UM , Nil } )
                    If (nTpCtlBN != 0)
     					AAdd( aLinha, { "D1_OP" 	, A103OPBen(cAliasSD2, nTpCtlBN) , Nil } )
                    EndIf
					If Rastro((cAliasSD2)->D2_COD) .And. (cAliasSF4)->F4_ESTOQUE == "S"
						AAdd( aLinha, { "D1_LOTECTL", (cAliasSD2)->D2_LOTECTL, ".T." } )
						If (cAliasSD2)->D2_ORIGLAN == "LO"
							If Rastro((cAliasSD2)->D2_COD,"L") .AND. !Empty((cAliasSD2)->D2_NUMLOTE)
								AAdd( aLinha, { "D1_NUMLOTE", Nil , ".T." } )
							Else
								AAdd( aLinha, { "D1_NUMLOTE", (cAliasSD2)->D2_NUMLOTE, ".T." } )
							EndIf
						Else
							AAdd( aLinha, { "D1_NUMLOTE", (cAliasSD2)->D2_NUMLOTE, ".T." } )
						EndIf

						AAdd( aLinha, { "D1_DTVALID", (cAliasSD2)->D2_DTVALID, ".T." } )
						AAdd( aLinha, { "D1_POTENCI", (cAliasSD2)->D2_POTENCI, ".T." } )
						SB8->(dbSetOrder(3)) // FILIAL+PRODUTO+LOCAL+LOTECTL+NUMLOTE+B8_DTVALID
						If 	SB8->(MsSeek(xFilial("SB8")+(cAliasSD2)->D2_COD + (cAliasSD2)->D2_LOCAL + (cAliasSD2)->D2_LOTECTL + (cAliasSD2)->D2_NUMLOTE))
								AAdd( aLinha, { "D1_DFABRIC", SB8->B8_DFABRIC, ".T." } )
						Endif
					EndIf
					cNFORI  := (cAliasSD2)->D2_DOC
					cSERIORI:= (cAliasSD2)->D2_SERIE
					cITEMORI:= (cAliasSD2)->D2_ITEM
					If cTipo == "D"
						SF4->(dbSetOrder(1))
						If SF4->(MsSeek(xFilial("SF4")+(cAliasSD2)->D2_TES)) .And. SF4->F4_PODER3$"D|R"
							If SF4->(MsSeek(xFilial("SF4")+(cAliasSF4)->F4_CODIGO)) .And. SF4->F4_PODER3 == "N"
								cNFORI  := ""
								cSERIORI:= ""
								cITEMORI:= ""
								Help(" ",1,"A100NOTES")
							EndIf
							If SF4->(MsSeek(xFilial("SF4")+(cAliasSF4)->F4_CODIGO)) .And. SF4->F4_PODER3 == "R"
								cNFORI  := ""
								cSERIORI:= ""
								cITEMORI:= ""
							    Help(" ",1,"A103TESNFD")
							EndIf
						EndIf
					EndIf
					AAdd( aLinha, { "D1_NFORI"  , cNFORI   			      , Nil } )
					AAdd( aLinha, { "D1_SERIORI", cSERIORI  		      , Nil } )
					AAdd( aLinha, { "D1_ITEMORI", cITEMORI   			  , Nil } )
					AAdd( aLinha, { "D1_ICMSRET", ((cAliasSD2)->D2_ICMSRET / (cAliasSD2)->D2_QUANT )*nSldDev , Nil })
					If (cAliasSF4)->F4_PODER3=="D"
						AAdd( aLinha, { "D1_IDENTB6", (cAliasSD2)->D2_NUMSEQ, Nil } )
					Endif

					//Obtém o valor do Acrescimo Financeiro na Nota de Origem e faz o rateio //
					If (cAliasSD2)->D2_VALACRS >0
						AAdd( aLinha, { "D1_VALACRS", ((cAliasSD2)->D2_VALACRS / (cAliasSD2)->D2_QUANT )*nSldDev , Nil })
					Endif

					If ExistBlock("MT103LDV")
						aLinha := ExecBlock("MT103LDV",.F.,.F.,{aLinha,cAliasSD2})
					EndIf

					If !(Empty((cAliasSD2)->D2_CCUSTO ))
						AAdd( aLinha, { "D1_CC"  , (cAliasSD2)->D2_CCUSTO  , Nil } )
					EndIf

					AAdd( aLinha, { "D1RECNO", (cAliasSD2)->SD2RECNO, Nil } )

					AAdd( aItens, aLinha)
				EndIf
			Else
				lHelpTes := .F.
			EndIf
		Else
			nHpP3 := 1
		Endif
		DbSelectArea(cAliasSD2)
		dbSkip()
	EndDo

	(cAliasSD2)->(DbCloseArea())

	// Verifica se nenhum item foi processado
	If !lDevCode
		lDevolucao := .F.
	EndIf
	DbSelectArea("SD2")

EndIf

Return lDevolucao




/*/{Protheus.doc} WndBrwMrk
//TODO apresenta uma markbrowse dentro de uma dialog de acordo com os parametros informados.
@author reynaldo
@since 04/06/2018
@version 1.0
@return ${return}, ${return_description}
@param cTitle, characters, descricao
@param cAliasTRB, characters, descricao
@param lFieldMark, logical, descricao
@param aSeeks, array, descricao
@param aCols, array, descricao
@param aLegends, array, descricao
@param lRetornar, logical, descricao
@type function
/*/
User Function CpBrwMrk( cTitle, cAliasTRB, lFieldMark, aSeeks, aCols, aLegends, lRetornar )
Local oPanel
Local nCnt 		:= 0
Local aPosPanel := {}
Local aPosDialog:= {}
Local oSize
Local oDlgSelect
Local nOpcao := 0

DEFAULT lFieldMark	:=.F.
DEFAULT aSeeks		:= {}
DEFAULT aCols		:= {}
DEFAULT aLegends	:= {}

	//Faz o calculo automatico de dimensoes de objetos
	oSize := FwDefSize():New(.T.)

	oSize:lLateral := .F.
	oSize:lProp	:= .T. // Proporcional
	
	oSize:AddObject( "BROWSE" ,75 ,100 ,.T. ,.T. ) // Totalmente dimensionavel
		
	oSize:Process() // Dispara os calculos		
	
	aPosDialog:={oSize:aWindSize[1]*0.75;
				,oSize:aWindSize[2]*0.75;
				,oSize:aWindSize[3]*0.75;
				,oSize:aWindSize[4]*0.75}

	aPosPanel := aPosDialog
	 
	DEFINE MSDIALOG oDlgSelect TITLE cTitle FROM aPosDialog[1],aPosDialog[2] ;
	 			TO aPosDialog[3],aPosDialog[4] ;
	 			Of oMainWnd ;
	 			PIXEL

	oPanel := TPanel():New(aPosPanel[1],aPosPanel[2],'',oDlgSelect,, .T., .T.,, ,aPosPanel[3],aPosPanel[4])
	oPanel:Align := CONTROL_ALIGN_ALLCLIENT

	//Agora iremos usar a classe FWMarkBrowse
    oBrowse:= FWMarkBrowse():New()
    
    oBrowse:SetOwner(oPanel)	
    oBrowse:SetDescription("") //Titulo da Janela
    oBrowse:SetAlias(cAliasTRB) //Indica o alias da tabela que será utilizada no Browse
    oBrowse:SetTemporary() //Indica que o Browse utiliza tabela temporária
    oBrowse:SetColumns(MBColumn(aCols)) //Adiciona uma coluna no Browse em tempo de execução
    
    oBrowse:DisableReport() // Desabilita a impressão das informações disponíveis no Browse
    oBrowse:DisableConfig() // Desabilita a utilização do Browse
    oBrowse:SetIgnoreARotina(.T.) // Indica que a mbrowse, ira ignorar a variavel private aRotina na construção das opções de menu.
    oBrowse:SetMenuDef("") 
    oBrowse:SetWalkThru(.F.) //Habilita a utilização da funcionalidade Walk-Thru no Browse
    oBrowse:SetAmbiente(.F.) //Habilita a utilização da funcionalidade Ambiente no Browse
 
    oBrowse:oBrowse:SetDBFFilter(.F.)
    oBrowse:oBrowse:SetUseFilter(.F.) //Habilita a utilização do filtro no Browse
    oBrowse:oBrowse:SetFixedBrowse(.T.)
    oBrowse:oBrowse:SetFilterDefault("") //Indica o filtro padrão do Browse

    If Empty(aSeeks)
    	oBrowse:oBrowse:SetSeek(.F.)
    Else
    	oBrowse:oBrowse:SetSeek(.T.,aSeeks) //Habilita a utilização da pesquisa de registros no Browse
    EndIf

    If lFieldMark
        oBrowse:SetFieldMark("TRB_OK") //Indica o campo que deverá ser atualizado com a marca no registro
        oBrowse:SetAllMark({|| MarkAll(oBrowse) })
    EndIf

    //Permite adicionar legendas no Browse
    For nCnt := 1 to len(aLegends)
        oBrowse:AddLegend(aLegends[nCnt,1],aLegends[nCnt,2],aLegends[nCnt,3])
    Next nCnt
    
    //Adiciona botoes na janela
    If lRetornar
    	oBrowse:AddButton("Retornar" ,{|| nOpcao := 2 ,lLoop := .T. , oDlgSelect:End()} ,NIL ,NIL ,2) // "Retornar"
    Else
    	oBrowse:AddButton("Confirmar" ,{|| GrvOK(cAliasTRB),lLoop := .T. , nOpcao := 1 ,oDlgSelect:End()} ,NIL ,NIL ,2) // "Confirmar"
    EndIF
	oBrowse:AddButton("Sair" ,{||  oDlgSelect:End()}  ,NIL ,NIL ,2) // "Sair"
    
    //Método de ativação da classe
    oBrowse:Activate()
    
    oBrowse:oBrowse:SetFocus() //Seta o foco na grade

	ACTIVATE MSDIALOG oDlgSelect CENTERED
	
	aSize(aSeeks ,0)
	aSeeks := NIL
	
	aSize(aCols ,0)
	aCols := NIL
	
	aSize(aLegends ,0)
	aLegends := NIL
	
	aSize(aPosDialog ,0)
	aPosDialog := NIL
	
	aSize(aPosPanel ,0)
	aPosPanel := NIL	
Return nOpcao

/*/{Protheus.doc} MBColumn
//TODO Monta as colunas da markBrowse
@author reynaldo
@since 04/06/2018
@version 1.0
@return ${return}, ${return_description}
@param aCols, array, descricao
@type function
/*/
Static Function MBColumn(aCols)
Local nCnt		:= 0
Local aColumns	:= {}

For nCnt := 1 To Len(aCols)
	aAdd(aColumns,FWBrwColumn():New())
	aColumns[Len(aColumns)]:SetData( &("{||"+aCols[nCnt,1]+"}") )
	aColumns[Len(aColumns)]:SetTitle(aCols[nCnt,2]) 
	aColumns[Len(aColumns)]:SetSize(aCols[nCnt,4]) 
	aColumns[Len(aColumns)]:SetDecimal(aCols[nCnt,5])
Next nCnt 

Return aColumns	


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} MarkAll
Funcao para inverter todos os registros da MarkBrowse.
		
@return	ExpL	Verdadeiro / Falso
@author	Leandro Nishihata
/*/        
//--------------------------------------------------------------------------------

Static Function MarkAll(oMrkBrowse)
	Local cAlias		:= oMrkBrowse:Alias()
	 
	While (cAlias)->(!Eof())
		If (!oMrkBrowse:IsMark())
			RecLock((cAlias),.F.)
			(cAlias)->TRB_OK  := oMrkBrowse:Mark()
			(cAlias)->(MsUnLock())
		Else
			RecLock(cAlias,.F.)
			(cAlias)->TRB_OK  := ""
			(cAlias)->(MsUnLock())
		EndIf
		(cAlias)->(DbSkip())
	End

	oBrowse:Refresh()
	oBrowse:SetFilterDefault( "" )

Return( .T. )

/*/{Protheus.doc} GrvOK
//TODO Grava X no registro posicionado na tabela temporaria.
@author reynaldo
@since 04/06/2018
@version 1.0
@return ${return}, ${return_description}
@param cAliasTRB, characters, descricao
@type function
/*/
Static Function GrvOK(cAliasTRB)
Local cAliasOld := Alias()

RecLock(cAliasTRB)
(cAliasTRB)->TRB_OK := "X"
MsUnLock()

If !Empty(cAliasOld)
	dbSelectArea(cAliasOld)
EndIf

Return .T.