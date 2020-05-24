#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TBICONN.CH"





/*/{Protheus.doc} CP01MTXML
Motor Fiscal - Busca XML das notas fiscais via Integração
CONSIDERA QUE ESTA POSICIONADO NA FILIAL CORRETA
@author Augusto Ribeiro | www.compila.com.br
@since 26/03/2019
@version undefined
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
//User Function CP01MFXML(cCNPJ, cTipoXml)
User Function CP01MFXML(cFilProc, cTipoXml)
Local aRet		:= {.F., ""}
Local cQuery	:= ""
Local nI, oJson, oRestSend
Local aHeadAPI	:= {}
Local cJson		:= ""
Local cJsonRet	:= ""
Local cHostAPI	:= alltrim(GETMV("CP01_MFURL",.F.,"https://api.motorfiscal.com.br"))
Local cPathAPI	:=  "/integracoes/downloadXml"
Local cXML		:= ""
Local lExiteNF	:= .F.
Local nLimitLoop	:= 1 //| Limite de execução da chamada em Loop do WS |
Local nCallAPI		:= 0
//Local cDirSave	:= GETMV("CP01_MFSAV",.F.,"\data_custom\motorfiscal\xml\") //DirSave(PATH_SAVE_PDF)
//Local cDirSave	:= GETMV("CP01_MFSAV",.F.,"\data_xml\temp\") //DirSave(PATH_SAVE_PDF)
Local cDirSave		:= LOWER(ALLTRIM(U_CP01005G("10", "XMLTEMP"))) //DirSave(PATH_SAVE_PDF)
Local lSobresc		:= ""
Local cNomeArq		:= ""

Local cDtRegMf, cDtNewMF, lExistArq
Local nPagAPI	:= 0
Local cFullSave	:= ""

Local nPgAtual	:= 0
Local nPgProx	:= 0
Local nPgTotal	:= 0
Local lFirst	:= .T.
Local nQtdeXML	:= 0
Local cParamData	:= ""
Local cCNPJ		:= ""
Local cToken 	:= ""


/*------------------------------------------------------ Augusto Ribeiro | 03/05/2019 - 8:41:14 AM
	Posiciona na filial enviada
------------------------------------------------------------------------------------------*/

/*---------------------------------------
	Realiza a TROCA DA FILIAL CORRENTE 
-----------------------------------------*/
_cCodEmp 	:= SM0->M0_CODIGO
_cCodFil	:= SM0->M0_CODFIL
_cFilNew	:= cFilProc //| CODIGO DA FILIAL DE DESTINO 

IF _cCodEmp+_cCodFil <> _cCodEmp+_cFilNew
	CFILANT := _cFilNew
	opensm0(_cCodEmp+CFILANT)
ENDIF
cCNPJ	:= ALLTRIM(SM0->M0_CGC)

cToken 	:= ALLTRIM(U_CP01005G("10", "APITOKEN"))


cDirSave	:= LOWER(ALLTRIM(U_CP01005G("10", "XMLTEMP"))) //DirSave(PATH_SAVE_PDF)
lSobresc	:= GETMV("CP01_MFSOV",.F.,.F.) //| Sobrescreve arquivo existente na pastas|

aDirSave		:= DirSave(cDirSave)

IF aDirSave[1]	.AND. !EMPTY(cToken)
	
	IF cTipoXml == "NFE"
		cParamData := "CP01_MFNFE"
	ELSEIF cTipoXml == "CTE"
		cParamData := "CP01_MFCTE"
	ENDIF
	
	//cDtRegMf	:= alltrim(GETMV(cParamData,.F.,"'2019-01-01'")) //| Data e Pagina da ultima busca realizada.
//U_GetAd("MV_CXPPSS","C","Host da API Caixa Pleres - Titulos",'12345'  )
 	cDtRegMf	:=  GetAd(cParamData,"C","Data ultimo xml obtido.","2019-01-01",cFilProc)
 	IF !EMPTY(cDtRegMf)
 		cDtNewMF	:= cDtRegMf
 	ELSE 
 		cDtNewMF	:= ""
 	ENDIF 
 	
	
	lExiteNF	:= .T.
	WHILE lExiteNF
	
		/*------------------------------------------------------ Augusto Ribeiro | 27/03/2019 - 11:40:24 AM
			Controle para evitar Loop Infinito
		------------------------------------------------------------------------------------------*/
		nCallAPI++
		IF nCallAPI > nLimitLoop
			lExiteNF	:= .F.
			EXIT
		ENDIF

			
		oJson		:= NIL
		aHeadAPI	:= {}
		aadd(aHeadAPI, "Content-Type: application/json")
//		aadd(aHeadAPI, "Authorization: "+alltrim(GETMV("CP01_MFTOK",.F.,"DSqwwJTrzaguIW6OgdrQbJj4G6QnFfUdeK5sP8wdVm8mzDh9DCxVaLIrWj7Q")))
		aadd(aHeadAPI, "Authorization: "+ cToken)
		
		cJson	:= ""
		cJson	+= "{"
		cJson	+= U_cpxToJson("CNPJ",cCNPJ)+","
		cJson	+= U_cpxToJson("TIPO_DOC",cTipoXml)+","
		cJson	+= U_cpxToJson("DT_REG", cDtNewMF)+","
		cJson	+= U_cpxToJson("FLUXO_DOC",1)+","
		cJson	+= U_cpxToJson("PAGE", nPagAPI)+","
		cJson	+= U_cpxToJson("STATUS", "")
		//cJson	+= U_cpxToJson("STATUS", "INTEGRADO") //| teste|
		cJson	+= "}" 
		
		oRestSend	:= FWRest():New(cHostAPI)
		oRestSend:SetPostParams(cJson)
		oRestSend:setPath(cPathAPI)
		If oRestSend:Post(aHeadAPI)
			cJsonRet	:= oRestSend:GetResult()
			IF FWJsonDeserialize(cJsonRet,@oJson)
			
			
				IF AttIsMemberOf(oJson , "_LINKS")
					IF !AttIsMemberOf(oJson:_LINKS , "TOTAL_PAGES")						
						aRet[2] += "Não existem registros a serem processados [TOTAL_PAGES] "
						EXIT
					ENDIF				
				ELSE
					aRet[2] += "Não existem registros a serem processados [_LINKS] "
					EXIT
				ENDIF
				
				/*------------------------------------------------------ Augusto Ribeiro | 30/04/2019 - 8:35:06 AM
					Controle de paginacao chamada WS
				------------------------------------------------------------------------------------------*/
				//nPgAtual	:= oJson:_LINKS:CURRENT_PAGE
				//nPgProx		:= oJson:_LINKS:NEXT_PAGE
				IF lFirst
					nLimitLoop	:= oJson:_LINKS:TOTAL_PAGES
					lExiteNF	:= .T.
					lFirst		:= .f.
				ENDIF
				
			
				/*------------------------------------------------------ Augusto Ribeiro | 30/04/2019 - 9:20:06 AM
					Carrega dados no array pois quendo é realizada a chamada de outro API 
					o Objeto Json é sobrescrito... coisas de Protheus :-)
				------------------------------------------------------------------------------------------*/
				aDadosJson	:= {}
				nQtdeXML	:= len(oJson:ITENS)
				FOR nI := 1 to nQtdeXML
					aadd(aDadosJson, {oJson:ITENS[nI]:CHV, oJson:ITENS[nI]:DT_REG, oJson:ITENS[nI]:XML} )
				NEXT nI
				
				
				FOR nI	:= 1 to nQtdeXML
					lAtuSt	:= .F.
					cChvNF		:= aDadosJson[nI,1]
					cNomeArq	:= lower(ALLTRIM(cChvNF))+".xml"
					cDtNewMF	:= alltrim(aDadosJson[nI,2])
					
					cFullSave	:= aDirSave[3]+cNomeArq
					lExistArq	:= FILE(cFullSave)
					IF (lExistArq .AND. lSobresc) .OR. !lExistArq
					
						
					
						cXML		:= ""
						cDec64		:= DECODE64(aDadosJson[nI,3])
						nLenGZ		:= LEN(cDec64)
						GzStrDecomp(cDec64, nLenGZ, @cXML ) 
					
						IF MemoWrite( cFullSave, cXML)
							lAtuSt	:= .T.
							CONOUT("U_CP01MFXML", "Sucesso. ["+cFullSave+"]")
						ELSE							
							CONOUT("U_CP01MFXML", "Falha. ["+cFullSave+"]")
						ENDIF
					ELSE
						lAtuSt	:= .T.
						CONOUT("U_CP01MFXML", "Arquivo já existe ["+cFullSave+"]")
					ENDIF
					
					/*----------------------------------
						Altera status no motor fiscal.
					-------------------------------------*/
					IF lAtuSt
						aRetAux	:= U_CP01MFST(cCNPJ, cChvNF, "INTEGRADO",cTipoXml)
						//aRetAux	:= U_CP01MFST(cCNPJ, cChvNF, "",cTipoXml) // teste
						IF !aRetAux[1]
							CONOUT("U_CP01MFXML U_CP01MFST", aRetAux[2] )
						ENDIF
					ENDIF
					
				NEXT nI
				
				
				IF cDtNewMF <> cDtRegMf
					cDtRegMf	:= cDtNewMF
					PUTMV(cParamData,cDtNewMF)					
				ENDIF
			ELSE
				aRet[2]	:= "Invalid Json"
				lExiteNF	:= .F.
			ENDIF	
		ELSE
			cAux	:= oRestSend:GetResult()	
			aRet[2] += oRestSend:GetLastError()+iif(VALTYPE(cAux)=="C",cAux,"")
			lExiteNF	:= .F.
		ENDIF
	ENDDO
else
	aRet[2] += "Não foi possivel localizar o diretorio para salvar o XML ["+cDirSave+"]"
	lExiteNF	:= .F.
endif


/*---------------------------------------
	Restaura FILIAL  
-----------------------------------------*/
IF _cCodEmp+_cCodFil <> _cCodEmp+_cFilNew
	CFILANT := _cCodFil
	opensm0(_cCodEmp+CFILANT)			 			
ENDIF   	

Return(aRet)





/*/{Protheus.doc} DirSave
Retornar/Criar caminho onde será armazenado o comprovante de acordo com a data informada.
@author Augusto Ribeiro | www.compila.com.br
@since 14/01/2015
@version 1.0
@param ${dDataRef}, ${D}, ${Data de referencia - Utilizado para criar o diretorio onde ser armazenado o arquivo}
@return aRet,  {.F., cMsgErro, cPaths}
/*/
Static Function DirSave(cPath)
Local aRet			:= {.F., "", ""}
Local cAnoMes, cDirComp, cCurDir, nAux
Local aPath, nI
Local cNewPath, aNewPath


/*
#DEFINE DIR_TEMP "\data_braspag\temp\"
#DEFINE DIR_IMPORTADO "\data_braspag\importado\"
*/

IF !EMPTY(cPath)

	//cNewPath	:= ALLTRIM(cPath)+LEFT(DTOS(DDATABASE),6)
	cNewPath	:= cPath
	
	cCurDir	:= CurDir()
	CurDir("\")
	/*------------------------------------------------------ Augusto Ribeiro | 27/11/2016 - 12:42:46 PM
		Verifica se o caminho existe, caso não, cria as patas
	------------------------------------------------------------------------------------------*/
	IF !ExistDir(cNewPath)
	
		aNewPath	:= StrTokArr(cNewPath, "\" )
		
		FOR nI := 1 to len(aNewPath)
		
			IF ExistDir(aNewPath[nI])
				CurDir(aNewPath[nI])
			ELSE
				nAux	:= MakeDir(aNewPath[nI])
				IF nAux == 0
					CurDir(aNewPath[nI])
				ELSE
					aRet[2] := "Nao foi possivel criar o diretorio ["+CurDir()+"\"+aNewPath[nI]+"]. Cod. Erro: "+alltrim(str(FError()))
					CONOUT("CP13000.PRW [DirSave] | "+aRet[2] )
					EXIT
				ENDIF			
			ENDIF
		
		NEXT nI	
	
	ENDIF
	
	
	IF ExistDir(cNewPath)
		aRet[1]	:= .t.
		aRet[3]	:= cNewPath+"\"
	ELSE
		aRet[2] := "Não foi possivel localiar o diretorio ["+cNewPath+"]"
	ENDIF

	CurDir(cCurDir) 	
ENDIF


Return(aRet)




/*/{Protheus.doc} CP01MFST
Atualiza Status no Motor Fiscal.
@author Augusto Ribeiro | www.compila.com.br
@since 30/04/2019
@version version
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function CP01MFST(cCNPJ, cChvNota, cStatus, cTipo)
Local cHostAPI	:= alltrim(GETMV("CP01_MFURL",.F.,"https://api.motorfiscal.com.br"))
Local cPathAPI	:=  "/nfe/statusErp"
Local aRet	:= {.F.,""}
Local oRestSend, oJson2, cAux
Local cJson	:= ""
Local aHeadAPI	:= {}


IF upper(cTipo) == "NFE"
	cPathAPI	:=  "/nfe/statusErp"
ELSEIF upper(cTipo) == "CTE"
	cPathAPI	:=  "/cte/statusErp"
ENDIF

oJson2		:= NIL
aHeadAPI	:= {}
aadd(aHeadAPI, "Content-Type: application/json")
aadd(aHeadAPI, "Authorization: "+alltrim(GETMV("CP01_MFTOK",.F.,"DSqwwJTrzaguIW6OgdrQbJj4G6QnFfUdeK5sP8wdVm8mzDh9DCxVaLIrWj7Q")))



cJson	:= ""
cJson	+= "{"
cJson	+= U_cpxToJson("chave",cChvNota)+","
cJson	+= U_cpxToJson("status", cStatus)+","
cJson	+= U_cpxToJson("cnpj",cCNPJ)
cJson	+= "}" 

oRestSend	:= FWRest():New(cHostAPI)
oRestSend:SetPostParams(cJson)
oRestSend:setPath(cPathAPI)
If oRestSend:Post(aHeadAPI)
	cJsonRet	:= oRestSend:GetResult()
	IF FWJsonDeserialize(cJsonRet,@oJson2)
		aRet[1]	:= .T.
	ELSE
		aRet[2]	:= "Invalid Json"
	ENDIF	
ELSE
	cAux	:= oRestSend:GetResult()	
	aRet[2] += oRestSend:GetLastError()+iif(VALTYPE(cAux)=="C",cAux,"")
ENDIF

Return(aRet)


/*/{Protheus.doc} CP01EML
Baixa XML Via API e Processa pasta TEMP
@author Jonatas Oliveira | www.compila.com.br
@since 02/05/2019
@version 1.0
/*/
User Function CP01API(aParam)
Local aParam
Local cEmpAut	//:= ALLTRIM(U_CP01005G("10", "XMLAPI"))
Local aEmpAut	:= {}

Default aParam := {}

Conout("###| U_CP01API - INICIO: "+DTOC(DATE())+" "+TIME())

PREPARE ENVIRONMENT EMPRESA aParam[1] FILIAL aParam[2]

	cEmpAut	:= ALLTRIM(U_CP01005G("10", "XMLAPI"))

	IF !EMPTY(cEmpAut)
		aEmpAut 	:= StrTokArr2(cEmpAut,"|", .F.)
		
		IF LEN(aEmpAut) > 0 
			For nI := 1 To Len(aEmpAut)
				U_CP01MFXML(ALLTRIM(aEmpAut[nI]),"NFE") //| Busca XML das NFE via Integração|
				U_CP01MFXML(ALLTRIM(aEmpAut[nI]),"CTE") //| Busca XML das CTE via Integração|					
			Next nI				
		ENDIF 		
		
	ENDIF
	
	U_CP01004("DIR")//|Move para pasta TEMP e processa a importacao 
RESET ENVIRONMENT	

Conout("###| U_CP01API - FIM: "+DTOC(DATE())+" "+TIME())

Return()




//-------------------------------------------------------------------
/*/{Protheus.doc} GetAd
Retorna  e cria parametro. 
@author  bruno.ferreira
@since   23/03/19
/*/
//-------------------------------------------------------------------
//
Static Function GetAd(cPar,cTp,cDesc,xVal,cFilPar)

Local xRet

Default cTp   := "C"
Default cDesc := "Inclusão Automática pelo GETAD"
Default cFilPar := Space(TamSX3("C5_FILIAL")[1])

SX6->(dbSetOrder(1))
If ! SX6->(dbSeek(cFilPar+cPar))

	RecLock("SX6",.T.)
	SX6->X6_FIL     := cFilPar
	SX6->X6_VAR     := cPar
	SX6->X6_TIPO    := UPPER(cTp)
	SX6->X6_DESCRIC := Left(cDesc,49) 
	SX6->X6_DSCSPA  := SX6->X6_DESCRIC
	SX6->X6_DSCENG  := SX6->X6_DESCRIC
	SX6->X6_CONTEUD := xVal
	SX6->X6_CONTSPA := SX6->X6_CONTEUD
	SX6->X6_CONTENG := SX6->X6_CONTEUD
	SX6->X6_PROPRI  := "U"
	SX6->X6_PYME    := "S"
	SX6->(msUnLock())		

EndIf

xRet := GetMV(cPar)

If UPPER(cTp) == "C"
	xRet := AllTrim(xRet)
EndIf	

Return xRet