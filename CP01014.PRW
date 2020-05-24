#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.ch"
#INCLUDE "TopConn.ch" 

#DEFINE EOL			chr(13)+chr(10) 

Static cTitulo	:= "Pedido de Compra"

/*/{Protheus.doc} CP01014
Mota Fiscal de Devolução
Rotina que apresenta interface para seleção dos itens que estão sendo devolvidos.
@author Augusto Ribeiro | www.compila.com.br
@since 19/02/2020
@version undefined
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
//User Function CP01014(aSF1Cab, aSF1Itens, aProdNCM)
User Function CP01014(cChvX, aChvO, dDtEmissao,cSerie, cCliFor, cLoja, cTpNF)
Local _lProcess	:= .F.       
Local cQuery	:= ""  
Local _aSay			:= {}
Local _aBotoes		:= {}
Local nY
Local aRet		:= {.F.,"",{}} 
Local aRetPar	:= {}
Local aParams	:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Necessario INCLI = .F. para evitar Loop automatico da funcao  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lInc		:= INCLUI         
INCLUI	:= .F.
         
Private cSCde, cSCAte, dDTSCde, dDTSCAte, cCodSolDe, cCodSolAte, cPCDe, cPCAte
Private lBtnConLog	:=	.F.
Private aProdNF		:= {}
Private _nColAnt	:= 0
Private aProdNCM                                                                                  

Private oVerde		:= LoadBitmap( GetResources(), "BR_VERDE")   //CHECKED    //LBOK  //LBTIK
Private oVermelho	:= LoadBitmap( GetResources(), "BR_VERMELHO") //UNCHECKED  //LBNO
Private oAmarelo	:= LoadBitmap( GetResources(), "BR_AMARELO") //UNCHECKED  //LBNO

Private oOk    	  	:= LoadBitmap( GetResources(), "LBOK")   //CHECKED    //LBOK  //LBTIK
Private oNo   	  	:= LoadBitmap( GetResources(), "LBNO") //UNCHECKED  //LBNO

Private nZ11QUANT		:= 0
Private nZ11RECNO		:= 0
Private nZ11SLDDEV		:= 0
PRIVATE nDEVXNFS		:= 0

Private nPSALDO		:= 0
Private nSD2RECNO	:= 0
Private nNFSXDEV	:= 0
Private nQTDEDEV	:= 0						

Private cChvXML		:= cChvX
Private aChvOrig	:= aChvO

PRIVATE cSerXML := cSerie
PRIVATE	cCliXML	:= cCliFor
PRIVATE cLjXML	:= cLoja
PRIVATE cTpXML	:= cTpNF

Private dtSaiDe		:= ctod("  /  /  ")
Private dtSaiAte	:= ctod("  /  /  ")


IF EMPTY(aChvOrig)
	AADD(aParams,{1,"Dt. Emissão NF Saide De",cToD("  /  /  "),,"","","",90,.F.,})
	AADD(aParams,{1,"Dt. Emissão NF Saide Até",dDtEmissao,,"","","",90,.T.,})
	
	If ParamBox(aParams,"Parametros",@aRetPar)
		dtSaiDe		:= aRetPar[1]
		dtSaiAte	:= aRetPar[2]
	endif
ENDIF

	/*
IF LEN(aSF1Cab) > 0 .AND. LEN(aSF1Itens) > 0
                 
	PRIVATE aF1Cabec 		:= aSF1Cab
	PRIVATE aF1Itens		:= aSF1Itens
	PRIVATE aPrdNCM			:= aProdNCM
	
	nF1FORNECE	:= aScan(aF1Cabec,{|x| ALLTRIM(x[1])=="F1_FORNECE"})
	nF1LOJA		:= aScan(aF1Cabec,{|x| ALLTRIM(x[1])=="F1_LOJA"}) 
	

	aRet	:= fDialogo()		
ENDIF */

aRet	:= fDialogo()
	 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura INCLUI ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
INCLUI := lInc
		
Return(aRet)

             

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fDialogo ºAutor  ³ Augusto Ribeiro	 º Data ³  10/09/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Monta Dialogo                                             º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fDialogo()  
Local aRet	:= {.F.,"",{}}
Local bOK		
Local bCanc		
//Local bRat
Local aButtons	:= {}   
Local oFLabels := TFont():New("MS Sans Serif",,026,,.F.,,,,,.F.,.T.)
                     
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis de posionamento dos campos ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private nNFSALDO, nNFD1COD, nNFD1QUANT
Private nPC7NUM, nPC7ITEM, nPC7PRECO, nPC7PRODUTO, nPC7QUANT, nPSALDO, nPC7RECNO

Private oDlgPed	:= NIL
Private aSizePed, aObjects, aInfo, aPosObj, aPosEnc
                
//bOK		:= {|| ListNF("A",@oLbxNF,@aHeadNF, @aDadoNF), oLbxNF:Refresh() } //{|| oDlgPed:End()}
//bRat	:= {|| oDlgPed:End()} 	
bCanc	:= {|| aRet[2]:="NF de Origem nao vinculada",oDlgPed:End()} 	
bOK		:= {|| ConfOK(@oDlgPed, @aRet)}

aButtons	:= {}
//aAdd(aButtons	,{"ENABLE" ,{|| U_CP0106R() },"Manutencao de Itens","Manutencao de Itens" })

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Dimensionamento da Janela - Parte Superior ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aSizePed 		:= MsAdvSize()		
aObjects	 := {}
 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso chamada da funcao tenha sito feita pelo botao consultar log ³
//³ Redimenciona tela para melhor visualizacao                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd( aObjects, {50,50, .T., .T.} )	
aAdd( aObjects, { 100, 100, .T., .T., .T.} )

aInfo := { aSizePed[ 1 ], aSizePed[ 2 ], aSizePed[ 3 ], aSizePed[ 4 ], 3, 3 }
aPosObj 	:= MsObjSize( aInfo, aObjects, .T. )                                                                         

aPosObj[1,1]	+= 12


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Dimensionamento da Janela - Parte Inferior ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aInfo := { aPosObj[2,2], aPosObj[2,1]+40, aPosObj[2,3], aPosObj[2,4]-30, 8, 3 }

aObjects	 := {}
aAdd( aObjects, { 100, 100, .T., .T.} )	

aPosObj2	:= MsObjSize( aInfo, aObjects, .T. , .T. )
     
aPosObj2[1,2] -= 8            

aPosEnc	:= {000,000,aPosObj[1,3]-aPosObj[1,1]-12,aPosObj[1,4]-aPosObj[1,2]-1}
		   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Dialog ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oDlgPed TITLE cTitulo FROM aSizePed[7],00 to aSizePed[6],aSizePed[5] OF oMainWnd PIXEL		

@ aPosObj[1,1]-12, aPosObj[1,2] SAY oLblSolicita PROMPT "Nota Fiscal "+IIF(cTpXML=="D","Devolução","Beneficiamento") SIZE 131, 014 OF oDlgPed FONT oFLabels COLORS 128, 16777215 PIXEL
@ aPosObj2[1,1],aPosObj2[1,2] SAY oLblPoint PROMPT "Nota Fiscal de Saída" SIZE 131, 014 OF oDlgPed FONT oFLabels COLORS 128, 16777215 PIXEL
          

//ÚÄÄÄÄÄÄÄÄ¿
//³ BOTOES ³
//ÀÄÄÄÄÄÄÄÄÙ
//oSCVisual		:= TButton():New(aPosObj[1,1]-12, aPosObj[1,4]-150,"Visualizar",oDlgPed,		{|| MSGRUN("Solicitação de Compras", "Aguarde...", {|| VisualSC(aDadoNF, oLbxNF:nAt)}) },045,010,,,,.T.,,"Visualizar Solicitação de Compras",,,,.F. )
//oSCAprov		:= TButton():New(aPosObj[1,1]-12, aPosObj[1,4]-100,"Aprovar",oDlgPed,		{|| U_ACOM06SC("A",aDadoNF),  ListNF("A",@oLbxNF,@aHeadNF, @aDadoNF), oLbxNF:Refresh() },045,010,,,,.T.,,"Aprovar Solicitação de Compras",,,,.F. )
//oSCReprov		:= TButton():New( aPosObj[1,1]-12, aPosObj[1,4]-50,"Reprovar",oDlgPed,	{|| U_ACOM06SC("R",aDadoNF), ListNF("A",@oLbxNF,@aHeadNF, @aDadoNF), oLbxNF:Refresh() },045,010,,,,.T.,,"Reprovar Solicitação de Compras",,,,.F. )


oPCVisual		:= TButton():New(aPosObj2[1,1]-12, aPosObj[1,4]-150,"Visualizar",oDlgPed,		{|| MSGRUN("Pedido de Compras", "Aguarde...", {|| VisualPC(aDadoPC, oLbxPC:nAt)}) },045,010,,,,.T.,,"Visualizar Pedido de Compras",,,,.F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta List Solicitacao de Compras ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
Private aHeadNF	:= {}       
Private aDadoNF	:= {}
Private oLbxNF	:= Nil            

ListNF("C",@oLbxNF,@aHeadNF, @aDadoNF)  
      
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta List Pedido de Compra       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
Private aHeadPC	:= {}       
Private aDadoPC	:= {}
Private oLbxPC	:= Nil            

ListSD2("C",@oLbxPC,@aHeadPC, @aDadoPC)
//IF ListSD2("C",@oLbxPC,@aHeadPC, @aDadoPC)
//	aRet[1] := .F.
//	aRet[2] := "Notas Fiscais de Saída não localizadas"
//	RETURN(aRet)
//ENDIF 

//oLbxPC:BHEADERCLICK	:= { |oObj,nCol| U_cpHeadOrd( oObj,nCol, .T.) }

//oLbxNF:bChange := {|| U_CCOM02LP("A",aDadoNF[oLbxNF:nAt, nSC1NUM],@oLbxPC,@aHeadPC, @aDadoPC), ListLog("A",@oLbxLog,@aHeadLog, @aDadoLog), oLbxPC:Refresh() }
oLbxNF:bChange := {|| U_CP0114CH(), oLbxPC:Refresh() }

oDlgPed:lMaximized := .T.		
ACTIVATE MSDIALOG oDlgPed CENTERED ON INIT Eval({ || EnChoiceBar(oDlgPed,bOK,bCanc,.F.,aButtons) })


//FOR nI := 1 TO LEN(aDadoPC)
//                
//	IF aDadoPC[nI,1]
//		aadd(aRet, aDadoPC[nI,nPC7RECNO])
//	ENDIF
//	
//Next nI

Return(aRet)         


/*/{Protheus.doc} fDialogo
Tratativa para o botão Salvar(Confirmar)
@author Jonatas Oliveira | www.compila.com.br
@since 23/07/2019
@version 1.0
/*/
Static Function ConfOK(oDlgPed, aRet)
Local lSucesso := .T.
Local nI
Local aRet	:= { .F., "", {}}

For nI := 1 To Len(aDadoNF)
	If aDadoNF[nI,nZ11SLDDEV] <> 0
		lSucesso := .F.
	EndIf
Next
	
	
If lSucesso
	
	
	aRet[1]	:= .T.
	//aRet[2]	:= {aHeadNF, aDadoNF}
	
	aRet[2]	:= ""	
	aRet[3]	:= MontaSD1()
	
	oDlgPed:End()
Else
	MsgBox("Nem todos os itens da nota fiscal foram atendidos","Atenção!","STOP")
EndIf
		
	
Return(aRet)




/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ListNF   ºAutor  ³ Augusto Ribeiro	 º Data ³  10/09/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  List Solicitacao de Compras                               º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ListNF(cOpcList,oLbxNF,aHeader, aDados)
Local lRet		:= .T.
Local cQuery	:= "" 
Local aCpoHeader, aLinha
Local cBCodLin	:= ""
Local nI, nY
     
aCpoHeader	:= {} 
aHeader		:= {} 
aDados		:= {}
                      

cQuery := " SELECT Z11_ITEM, Z11_CODPRO, Z11_DESPRO, Z11_CFOP, Z11_UM, Z11_QUANT, Z11_VLRUNI, Z11_VLRTOT, Z11_QUANT AS Z11_SLDDEV, Z11.R_E_C_N_O_ as Z11_RECNO "+CRLF
cQuery += " FROM "+RetSqlName("Z10")+" Z10 "+CRLF
cQuery += " INNER JOIN "+RetSqlName("Z11")+" Z11 "+CRLF
cQuery += " 	ON Z11_FILIAL = Z10_FILIAL "+CRLF
cQuery += " 	AND Z11_CHVNFE = Z10_CHVNFE "+CRLF
cQuery += " 	AND Z11.D_E_L_E_T_ ='' "+CRLF
cQuery += " WHERE Z10.D_E_L_E_T_ = '' "+CRLF
cQuery += " AND Z10_CHVNFE = '"+alltrim(cChvXML)+"' "+CRLF


If Select("TZ11") > 0
	TZ11->(DbCloseArea())
EndIf

DBUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TZ11",.F., .T.)						


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta aHeader ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
aadd(aHeader," ")                
aadd(aCpoHeader," ")
For nY := 1 To TZ11->(FCOUNT())
	IF ALLTRIM(FieldName(nY)) == "SALDO"
	   	aadd(aHeader,"Saldo")
		aadd(aCpoHeader,"SALDO")		
	ELSE                                            
		IF EMPTY(RetTitle(FieldName(nY)))
		   	aadd(aHeader,ALLTRIM(FieldName(nY)))		
		ELSE
		   	aadd(aHeader,ALLTRIM(RetTitle(FieldName(nY))))
		ENDIF
		aadd(aCpoHeader,FieldName(nY))
	ENDIF
Next nY	

aadd(aCpoHeader,"DEVXNFS")

nZ11QUANT		:= Ascan(aCpoHeader,"Z11_QUANT")
nZ11RECNO		:= Ascan(aCpoHeader,"Z11_RECNO")
nZ11SLDDEV		:= Ascan(aCpoHeader,"Z11_SLDDEV")
nDEVXNFS		:= Ascan(aCpoHeader,"DEVXNFS")



IF  TZ11->(!EOF())
	WHILE TZ11->(!EOF())
		aLinha	:= {}
		AADD(aLinha, .F.)		
		For nY := 1 To TZ11->(FCOUNT())

			IF VALTYPE(TZ11->&(FieldName(nY))) == "C"     
			
				aadd(aLinha, ALLTRIM(TZ11->&(FieldName(nY))) )
			ELSE                                              				
				aadd(aLinha, TZ11->&(FieldName(nY)) )
			ENDIF
		Next nY	 
		
		aadd(aLinha, {} )
	 	AADD(aDados, aLinha)
	 	
	
		TZ11->(DBSKIP()) 
	ENDDO	
ELSE
	aLinha	:= {}   
	AADD(aLinha, .F.)	
	For nY := 1 To TZ11->(FCOUNT())          
		IF ALLTRIM(FieldName(nY)) == "Z11_SLDDEV" .OR. ALLTRIM(FieldName(nY)) == "Z11_RECNO"     
			aadd(aLinha, 0 )		
		ELSE
			aadd(aLinha, CRIAVAR(FieldName(nY),.F.) )
		ENDIF
	Next nY	 

 	AADD(aDados, aLinha)	
ENDIF



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ cOpcList | C = Cria, A = Atualiza ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF cOpcList == "C"

	@ aPosObj[1,1],aPosObj[1,2] LISTBOX oLbxNF FIELDS HEADER ;
	   " ", "Campos" ;                                                                                                    
	   SIZE aPosObj[1,4],aPosObj[1,3] OF oDlgPed PIXEL 
ENDIF

oLbxNF:aheaders := aHeader
oLbxNF:SetArray( aDados )  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria string com Bloco de Codigo ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//cBCodLin	:= "Iif(aDados[oLbxNF:nAt,1],oVerde,oVermelho)"

cBCodLin	:= "Iif(aDados[oLbxNF:nAt,nZ11SLDDEV] == 0,oVerde,IIF(aDados[oLbxNF:nAt,nZ11SLDDEV] == aDados[oLbxNF:nAt,nZ11QUANT], oVermelho, oAmarelo))"

For nI := 2 To LEN(aHeader)
	IF nI > 1
		cBCodLin	+=", "
	endif
   cBCodLin	+= "aDados[oLbxNF:nAt,"+alltrim(str(nI))+"]"
Next nI	

cBCodLin	:= "oLbxNF:bLine := {|| {"+cBCodLin+"}}"
&(cBCodLin)

Return(lRet)
       


/*/{Protheus.doc} function_method_class_name
Lista Itens das notas relacionadas
@author Augusto Ribeiro | www.compila.com.br
@since 20/02/2020
@version version
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function ListSD2(cOpcList,oLbxPC,aHeader, aDados)
Local lRet		:= .F.
Local cQuery	:= "" 
Local aCpoHeader, aLinha
Local cBCodLin	:= ""
     
aCpoHeader	:= {} 
aHeader		:= {} 
aDados		:= {}

cQuery := " SELECT F2_DOC, F2_SERIE, F2_EMISSAO, D2_ITEM, D2_COD, B1_DESC, D2_UM, D2_QUANT, D2_PRCVEN, D2_TOTAL, (D2_QUANT-D2_QTDEDEV) AS SALDO, 0 as QTDEDEV, SD2.R_E_C_N_O_ AS SD2_RECNO "+CRLF
cQuery += " FROM "+RetSqlName("SF2")+" SF2  "+CRLF
cQuery += " INNER JOIN "+RetSqlName("SD2")+" SD2 "+CRLF
cQuery += " 	ON F2_FILIAL = D2_FILIAL "+CRLF
cQuery += " 	AND F2_DOC = D2_DOC "+CRLF
cQuery += " 	AND F2_SERIE = D2_SERIE "+CRLF
cQuery += " 	AND (D2_QUANT-D2_QTDEDEV) > 0 "+CRLF
cQuery += " 	AND SD2.D_E_L_E_T_ = '' "+CRLF
cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 "+CRLF
cQuery += " 	ON B1_FILIAL = '' "+CRLF
cQuery += " 	AND B1_COD = D2_COD "+CRLF
cQuery += " 	AND SB1.D_E_L_E_T_ = '' "+CRLF
//cQuery += " WHERE F2_CHVNFE =  '123454321' "+CRLF
cQuery += " WHERE F2_FILIAL = '"+XFILIAL("SF2")+"' "
IF cTpXML == "B"
	cQuery += " AND F2_TIPO = 'B'
ENDIF 

IF EMPTY(aChvOrig)
	//Parametros da ficha de opcional
	cQuery += " AND F2_EMISSAO BETWEEN '"+DTOS(dtSaiDe)+"' AND '"+DTOS(dtSaiAte)+"' "
	cQuery += " AND F2_CLIENTE = '"+cCliXML+"' "
	cQuery += " AND F2_LOJA = '"+cLjXML+"' "
ELSE
	cQuery += " AND F2_CHVNFE IN "+U_cpINQry(aChvOrig)
ENDIF
cQuery += " AND SF2.D_E_L_E_T_ = '' "+CRLF


If Select("TPC") > 0
	TPC->(DbCloseArea())
EndIf
          
cQuery	:= ChangeQuery(cQuery)
                   
MSGRUN("Aguarde....","SQL" ,		{|| dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),'TPC') } )					


IF TPC->(!EOF())
	lRet := .T.
ENDIF

TCSetField("TPC","F2_EMISSAO","D",08,00) 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta aHeader ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
aadd(aHeader," ")                
aadd(aCpoHeader," ")
For nY := 1 To TPC->(FCOUNT())
	IF ALLTRIM(FieldName(nY)) == "SALDO"
	   	aadd(aHeader,"Saldo")
		aadd(aCpoHeader,"SALDO")	
	ELSEIF ALLTRIM(FieldName(nY)) == "QTDEDEV"
	   	aadd(aHeader,"QTDE_UTILIZA")
		aadd(aCpoHeader,"QTDEDEV")		
			
	ELSE                                            
		IF EMPTY(RetTitle(FieldName(nY)))
		   	aadd(aHeader,ALLTRIM(FieldName(nY)))		
		ELSE
		   	aadd(aHeader,ALLTRIM(RetTitle(FieldName(nY))))
		ENDIF
		aadd(aCpoHeader,FieldName(nY))
	ENDIF
Next nY	

//aadd(aHeader,"QTDE_UTILIZA")
//aadd(aCpoHeader,"QTDEDEV") //| ARRAY DO ITEM RELACIONADO |

aadd(aCpoHeader,"NFSXDEV") //| ARRAY DO ITEM RELACIONADO |


nPSALDO		:= Ascan(aCpoHeader,"SALDO")
nSD2RECNO	:= Ascan(aCpoHeader,"SD2_RECNO")
nNFSXDEV	:= Ascan(aCpoHeader,"NFSXDEV")
nQTDEDEV	:= Ascan(aCpoHeader,"QTDEDEV")
					

IF TPC->(!EOF()) 			
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta aDados ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	WHILE TPC->(!EOF())
		aLinha	:= {}
		AADD(aLinha, .F.)		
		For nY := 1 To TPC->(FCOUNT())

			IF VALTYPE(TPC->&(FieldName(nY))) == "C"     
			
				aadd(aLinha, ALLTRIM(TPC->&(FieldName(nY))) )
			ELSE                                              				
				aadd(aLinha, TPC->&(FieldName(nY)) )
			ENDIF
		Next nY	 
		AADD(aLinha, 0)  //| nQTDEDEV |
		AADD(aLinha, {})  //| ARRAY DO ITEM RELACIONADO |
		
	 	AADD(aDados, aLinha)
	 	
		TPC->(DBSKIP())
	ENDDO  
ELSE
	aLinha	:= {}   
	AADD(aLinha, .F.)	
	For nY := 1 To TPC->(FCOUNT())          
		IF ALLTRIM(FieldName(nY)) == "SALDO" .OR. ALLTRIM(FieldName(nY)) == "SD2_RECNO" .OR. ALLTRIM(FieldName(nY)) == "QTDEDEV"
			aadd(aLinha, 0 )		
		ELSE
			aadd(aLinha, CRIAVAR(FieldName(nY),.F.) )
		ENDIF
	Next nY	 

 	AADD(aDados, aLinha)
ENDIF                     
	     
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ cOpcList | C = Cria, A = Atualiza ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF cOpcList == "C"

	@ aPosObj2[1,1]+15,aPosObj2[1,2] LISTBOX oLbxPC FIELDS HEADER ;
	   " ", "Campos" ;                                                                                                    
	   SIZE aPosObj2[1,4],aPosObj2[1,3] OF oDlgPed PIXEL ON dblClick(MARKSD2(@aDados),oLbxPC:Refresh())   //ON dblClick(VisualSC(aDadoNF, oLbxPC:nAt))
	   
ENDIF

oLbxPC:aheaders := aHeader
oLbxPC:SetArray( aDados )  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria string com Bloco de Codigo ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cBCodLin	:= "Iif(aDados[oLbxPC:nAt,1],oOk,oNo)"
For nI := 2 To LEN(aHeader)
	IF nI > 1
		cBCodLin	+=", "
	endif
   cBCodLin	+= "aDados[oLbxPC:nAt,"+alltrim(str(nI))+"]"
Next nI	

cBCodLin	:= "oLbxPC:bLine := {|| {"+cBCodLin+"}}"
&(cBCodLin)

Return(lRet)



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ VisualPC ºAutor  ³Augusto Ribeiro     º Data ³ 19/08/2010  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Visualiza a Pedido de Compras                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function VisualPC(aVetor, nPosReg)   
PRIVATE nTipoPed  := 1
PRIVATE bFiltraBrw:= {|| Nil }
PRIVATE cCadastro := "Pedido de Compra"
PRIVATE l120Auto  := .F. //( ValType(xAutoCab)=="A" .And. ValType(xAutoItens) == "A" )
PRIVATE aAutoCab  := NIL
PRIVATE aAutoItens:= NIL
PRIVATE aBackSC7  := {}
PRIVATE lPedido   := .T.
PRIVATE lGatilha  := .T.  // Para preencher aCols em funcoes chamadas da validacao (X3_VALID)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O parametro MV_VLDHEAD e' usado para validar ou nao o aCols          ³
//³ (uma linha ou todo), a partir das validacoes do aHeader -> VldHead() ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE lVldHead  := GetNewPar( "MV_VLDHEAD",.T. )
PRIVATE aRotina	:= {{OemToAnsi("Pesquisar"),"Ma097Pesq",   0 , 1, 0, .F.},; //"Pesquisar"
						{OemToAnsi("Consulta pedido"),"A097Visual",  0 , 2, 0, nil},; //"Consulta pedido"
						{OemToAnsi("Consulta Saldos"),"A097Consulta",0 , 2, 0, nil},; //"Consulta Saldos"
						{OemToAnsi("Liberar"),"A097Libera",  0 , 4, 0, nil},; //"Liberar"
						{OemToAnsi("Estornar"),"A097Estorna", 0 , 4, 0, nil},; //"Estornar"
						{OemToAnsi("Superior"),"A097Superi",  0 , 4, 0, nil},; //"Superior"
						{OemToAnsi("Transf. para Superior"),"A097Transf",  0 , 4, 0, nil},; //"Transf. para Superior"
						{OemToAnsi("Ausencia Temporaria"),"A097Ausente", 0 , 3, 0, nil},; //"Ausencia Temporaria"
						{OemToAnsi("Legenda"),"A097Legend",  0 , 2, 0, .F.}}  //"Legenda"	
PRIVATE INCLUI := .F., ALTERA	:= .F.



DbSelectArea("SC7") 
SC7->(DBSETORDER(1))
IF SC7->(DBSEEK(XFILIAL("SC7")+aVetor[nPosReg,nPC7NUM],.F.))
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Chama Visualização da rotina padrao ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	A120Pedido(,,2)
ENDIF

Return       
      
      

/*/{Protheus.doc} MARKSD2
Selecao dos itens do SD2 
@author Augusto Ribeiro | www.compila.com.br
@since 20/02/2020
@version version
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function MARKSD2(aVetor)  
Local nX,nAux, nSaldoPed
Local nSdlSai	:= 0
Local nSdlDev	:= 0
Local nQtdCons	:= 0
Local aAux, nPosAux, nI, nX, lexit
                  
	//aVetor[oLbxPC:nAt,1]	:= Iif(aVetor[oLbxPC:nAt,1],.F.,.T.)
	IF EMPTY(aVetor[oLbxPC:nAt,nZ11RECNO])
		RETURN()
	ENDIF
	
	IF !(aVetor[oLbxPC:nAt,1])
		
		
		IF aVetor[oLbxPC:nAt,nPSALDO] > 0 .and. aDadoNF[oLbxNF:nAt, nZ11SLDDEV] > 0
		

			IF aDadoNF[oLbxNF:nAt, nZ11SLDDEV] >= aVetor[oLbxPC:nAt, nPSALDO]
				nQtdCons	:= aDadoNF[oLbxNF:nAt, nZ11SLDDEV] - aVetor[oLbxPC:nAt, nPSALDO]
				nQtdUtilDev 					:= aVetor[oLbxPC:nAt, nPSALDO]										//quantidade utilizada da nf devolução
				aDadoNF[oLbxNF:nAt, nZ11SLDDEV] := nQtdCons
				aVetor[oLbxPC:nAt, nPSALDO]		:= 0
			ELSE
				nQtdCons	:= aDadoNF[oLbxNF:nAt, nZ11SLDDEV]
				nQtdUtilDev 					:= aDadoNF[oLbxNF:nAt, nZ11SLDDEV]									//quantidade utilizada da nf devolução
				aVetor[oLbxPC:nAt, nPSALDO]		:= aVetor[oLbxPC:nAt, nPSALDO]-nQtdCons
				aDadoNF[oLbxNF:nAt, nZ11SLDDEV] := 0
			ENDIF	
			
			aVetor[oLbxPC:nAt,1]			:= .T.
			//aDadoPC[oLbxPC:nAt,nQTDEDEV]	:= nQtdCons
			aDadoPC[oLbxPC:nAt,nQTDEDEV]	:= nQtdUtilDev	//quantidade utilizada
			
			aAux	:= {oLbxPC:nAt, nQtdUtilDev, aVetor[oLbxPC:nAt, nSD2RECNO] } //| {nPoscao NFS, nQtdeUsada, nRecSD2}  Dados Gravados no Array NF Devolucao |
			aadd(aDadoNF[oLbxNF:nAt, nDEVXNFS], aclone(aAux))
						
					
		ELSE
			FwHelpShow("Saldo","Saldo", "Este item não possui mais saldo disponivel para devolução", "")
		ENDIF
		
		
	ELSE
		lexit	:= .F.
		//FOR nI := 1 TO LEN(aDadoNF)
			nI	:= oLbxNF:nAt
			IF !EMPTY(aDadoNF[nI,nDEVXNFS])
				FOR nX := 1 TO  LEN(aDadoNF[nI,nDEVXNFS])
					IF aDadoNF[nI,nDEVXNFS,nX,1] == oLbxPC:nAt
						

						nQtdCons	:= aDadoNF[nI,nDEVXNFS,nX,2]
						aDadoNF[oLbxNF:nAt, nZ11SLDDEV] := aDadoNF[oLbxNF:nAt, nZ11SLDDEV]+nQtdCons
						aVetor[oLbxPC:nAt, nPSALDO]		:= aVetor[oLbxPC:nAt, nPSALDO]+nQtdCons						
						
						
						aVetor[oLbxPC:nAt,1]	:= .F.
						aVetor[oLbxPC:nAt,nQTDEDEV]	:= 0
						ADel( aDadoNF[nI,nDEVXNFS], nX )
						
						ASize( aDadoNF[nI,nDEVXNFS], LEN(aDadoNF[nI,nDEVXNFS])-1 )
						lexit := .T.
						EXIT 
					ENDIF
				NEXT
			ENDIF
			
//			IF lexit
//				EXIT
//			ENDIF
		//NEXT
		
	
	//ELSE 		
	/*
		nSdlDev	:= aDadoNF[oLbxNF:nAt, nZ11SLDDEV]	
		IF nSdlDev > 0 
			IF aDadoNF[oLbxNF:nAt, nZ11SLDDEV] >= aVetor[oLbxPC:nAt, nPSALDO]
				nQtdCons	:= aDadoNF[oLbxNF:nAt, nZ11SLDDEV] - aVetor[oLbxPC:nAt, nPSALDO]
				aDadoNF[oLbxNF:nAt, nZ11SLDDEV] := nQtdCons
				aVetor[oLbxPC:nAt, nPSALDO]		:= 0
			ELSE
				nQtdCons	:= aVetor[oLbxPC:nAt, nPSALDO]-aDadoNF[oLbxNF:nAt, nZ11SLDDEV]
				aVetor[oLbxPC:nAt, nPSALDO]		:= nQtdCons
				aDadoNF[oLbxNF:nAt, nZ11SLDDEV] := 0
			ENDIF
			
			
			aadd(aVetor[oLbxPC:nAt,nNFSXDEV], {oLbxNF:nAt, nQtdCons}) 
		ELSE
			Aviso("Sem Saldo", "Item da NF de Devolução não possui saldo para retorno. Selecione outro item no painel superior",{"Voltar"},1)
		ENDIF
		*/
	ENDIF



	oLbxNF:Refresh()
	oLbxPC:Refresh()		
	
Return
        

Static Function ATUMODEL()
//	Local nTotLen 	:= 0 
	Local cChvZ11	:= ""
	Local aZ11Lim 	:= {}
	Local AZ11IMP 	:= {}
	Local nRecSA5	:= 0 
	Local nTotCpo	:= 0 
	Local aRecZ16	:= {}
	Local cFornece	:= ""
	Local cLjForne	:= ""
	Local nPosLT	:= 0
	Local nPosLTF	:= 0
	Local nPosLTD	:= 0
	
//	nTotLen	:= oModZ16:Length()
	cChvZ11	:= Z10->Z10_FILIAL + Z10->Z10_CHVNFE + Z10->Z10_TIPARQ
	
	DBSELECTAREA("Z16")
	Z16->(DBSETORDER(1))//|Z11_FILIAL+Z11_CHVNFE+Z11_TIPARQ+Z11_ITEM|				
	Z16->(DBGOTOP())
	
	Z11->(DBGOTOP())

	IF Z16->(DBSEEK( cChvZ11 ))
		WHILE Z16->(!EOF()) .AND. cChvZ11 == Z16->Z16_FILIAL + Z16->Z16_CHVNFE + Z16->Z16_TIPARQ

			//|Deleta os Itens do XML|
			IF Z11->(DBSEEK( Z16->Z16_FILIAL + Z16->Z16_CHVNFE + Z16->Z16_TIPARQ + ALLTRIM( STR(Z16->Z16_ITXML) ))) 
				WHILE Z11->(!EOF()) .AND.  Z16->Z16_FILIAL + Z16->Z16_CHVNFE + Z16->Z16_TIPARQ == Z11->(Z11_FILIAL + Z11_CHVNFE + Z11_TIPARQ)
					
					IF ALLTRIM( STR(Z16->Z16_ITXML) )  == ALLTRIM( STR(Z11->Z11_ITEM))
						aZ11Lim := {}
						
						AADD(aZ11Lim , Z11->Z11_ITEM)//|1
						AADD(aZ11Lim , Z11->Z11_QUANT)//|2
						AADD(aZ11Lim , Z11->Z11_ICORIG )//|3
						AADD(aZ11Lim , Z11->Z11_ICCST  )//|4
						AADD(aZ11Lim , Z11->Z11_ICVLR  )//|5
						AADD(aZ11Lim , Z11->Z11_ICSTBC )//|6
						AADD(aZ11Lim , Z11->Z11_ICSTAL )//|7
						AADD(aZ11Lim , Z11->Z11_IPICST )//|8
						AADD(aZ11Lim , Z11->Z11_PISCST )//|9
						AADD(aZ11Lim , Z11->Z11_CFCST  )//|10
						AADD(aZ11Lim , Z11->Z11_POSIPI )//|11
						AADD(aZ11Lim , Z11->Z11_NUMPC  )//|12
						AADD(aZ11Lim , Z11->Z11_ITEMPC )//|13
						AADD(aZ11Lim , Z11->Z11_NFORIG )//|14
						AADD(aZ11Lim , Z11->Z11_SERORI )//|15
						AADD(aZ11Lim , Z11->Z11_VLRDES )//|16
						AADD(aZ11Lim , Z11->Z11_ICBC   )//|17
						AADD(aZ11Lim , Z11->Z11_ICALQ  )//|18
						AADD(aZ11Lim , Z11->Z11_ICSTVL )//|19
						AADD(aZ11Lim , Z11->Z11_IPIBC  )//|20
						AADD(aZ11Lim , Z11->Z11_IPIALQ )//|21
						AADD(aZ11Lim , Z11->Z11_IPIVLR )//|22
						AADD(aZ11Lim , Z11->Z11_PISBC  )//|23
						AADD(aZ11Lim , Z11->Z11_PISALQ )//|24
						AADD(aZ11Lim , Z11->Z11_PISVLR )//|25
						AADD(aZ11Lim , Z11->Z11_CFBC   )//|26
						AADD(aZ11Lim , Z11->Z11_CFALQ  )//|27
						AADD(aZ11Lim , Z11->Z11_CFVLR  )//|28
						AADD(aZ11Lim , Z11->Z11_IIBC   )//|29
						AADD(aZ11Lim , Z11->Z11_IIADUA )//|30
						AADD(aZ11Lim , Z11->Z11_IIVLR  )//|31
						AADD(aZ11Lim , Z11->Z11_IIIOF  )//|32
						
						Z11->(RecLock("Z11",.F.))
							Z11->(DbDelete())		
						Z11->(MsUnLock())	
						
						AADD(aZ11Imp,aZ11Lim)
					ENDIF 
					
					Z11->(DBSKIP())
				ENDDO
			ENDIF
			
			AADD(aRecZ16, Z16->( RECNO()))
			
			Z16->(DBSKIP())
		ENDDO
	ENDIF 

	Z16->(DBGOTOP())

	IF LEN(aRecZ16) > 0 
		For nZ	:= 1 To Len(aRecZ16)
			
			Z16->(DBGOTO(aRecZ16[nZ]))
			
			nItem := U_CP0113I(Z16->Z16_FILIAL , Z16->Z16_CHVNFE , Z16->Z16_TIPARQ)
			
			DBSELECTAREA("Z11")
			RegToMemory("Z11",.T.)
	
			nItem ++
	
			M->Z11_FILIAL		:= xFilial("Z11")
			M->Z11_TIPARQ       := Z16->Z16_TIPARQ
			M->Z11_CHVNFE       := Z16->Z16_CHVNFE
			M->Z11_NUMNFE       := Z16->Z16_NUMNFE 
			M->Z11_SERIE        := Z16->Z16_SERIE
			M->Z11_CNPJ         := Z16->Z16_CNPJ
			M->Z11_ITEM         := nItem
			M->Z11_CODPRO       := Z16->Z16_CODPRO
			M->Z11_DESPRO       := Z16->Z16_DESPRO
			M->Z11_CFOP         := Z16->Z16_CFOP
			M->Z11_UM           := Z16->Z16_UM
			M->Z11_QUANT        := Z16->Z16_QUANT
			M->Z11_VLRUNI       := Z16->Z16_VLRUNI
			M->Z11_VLRTOT       := Z16->Z16_VLRTOT
			M->Z11_LOTEFO       := Z16->Z16_LOTEFO
			M->Z11_LOTECT       := Z16->Z16_LOTECT 
			M->Z11_DTVALI       := Z16->Z16_DTVALI
			M->Z11_NUMPC       	:= Z16->Z16_NUMPC
			M->Z11_ITEMPC       := Z16->Z16_ITEMPC
			
			nPosZ11 := 0 
			nPosZ11 := aScan(aZ11Imp	, {|x| x[1] == Z16->Z16_ITXML })
			
			IF nPosZ11 > 0 
				//|Reacalcula impostos|
				M->Z11_ICORIG       := aZ11Imp[nPosZ11,3] 
				M->Z11_ICCST        := aZ11Imp[nPosZ11,4]  
				M->Z11_ICVLR        := aZ11Imp[nPosZ11,5]
				M->Z11_ICSTBC       := aZ11Imp[nPosZ11,6]
				M->Z11_ICSTAL       := aZ11Imp[nPosZ11,7]
				M->Z11_IPICST       := aZ11Imp[nPosZ11,8]
				M->Z11_PISCST       := aZ11Imp[nPosZ11,9]
				M->Z11_CFCST        := aZ11Imp[nPosZ11,10]
				M->Z11_POSIPI       := aZ11Imp[nPosZ11,11]
				M->Z11_NUMPC        := aZ11Imp[nPosZ11,12]
				M->Z11_ITEMPC       := aZ11Imp[nPosZ11,13]
				M->Z11_NFORIG       := aZ11Imp[nPosZ11,14]
				M->Z11_SERORI       := aZ11Imp[nPosZ11,15]
				
				M->Z11_VLRDES       := ( aZ11Imp[nPosZ11,16] / aZ11Imp[nPosZ11,2]) * Z16->Z16_QUANT
				M->Z11_ICBC         := ( aZ11Imp[nPosZ11,17] / aZ11Imp[nPosZ11,2]) * Z16->Z16_QUANT
				M->Z11_ICALQ        := ( aZ11Imp[nPosZ11,18] / aZ11Imp[nPosZ11,2]) * Z16->Z16_QUANT
				M->Z11_ICSTVL       := ( aZ11Imp[nPosZ11,19] / aZ11Imp[nPosZ11,2]) * Z16->Z16_QUANT
				M->Z11_IPIBC        := ( aZ11Imp[nPosZ11,20] / aZ11Imp[nPosZ11,2]) * Z16->Z16_QUANT
				M->Z11_IPIALQ       := ( aZ11Imp[nPosZ11,21] / aZ11Imp[nPosZ11,2]) * Z16->Z16_QUANT
				M->Z11_IPIVLR       := ( aZ11Imp[nPosZ11,22] / aZ11Imp[nPosZ11,2]) * Z16->Z16_QUANT
				M->Z11_PISBC        := ( aZ11Imp[nPosZ11,23] / aZ11Imp[nPosZ11,2]) * Z16->Z16_QUANT
				M->Z11_PISALQ       := ( aZ11Imp[nPosZ11,24] / aZ11Imp[nPosZ11,2]) * Z16->Z16_QUANT
				M->Z11_PISVLR       := ( aZ11Imp[nPosZ11,25] / aZ11Imp[nPosZ11,2]) * Z16->Z16_QUANT
				M->Z11_CFBC         := ( aZ11Imp[nPosZ11,26] / aZ11Imp[nPosZ11,2]) * Z16->Z16_QUANT
				M->Z11_CFALQ        := ( aZ11Imp[nPosZ11,27] / aZ11Imp[nPosZ11,2]) * Z16->Z16_QUANT
				M->Z11_CFVLR        := ( aZ11Imp[nPosZ11,28] / aZ11Imp[nPosZ11,2]) * Z16->Z16_QUANT
				M->Z11_IIBC         := ( aZ11Imp[nPosZ11,29] / aZ11Imp[nPosZ11,2]) * Z16->Z16_QUANT
				M->Z11_IIADUA       := ( aZ11Imp[nPosZ11,30] / aZ11Imp[nPosZ11,2]) * Z16->Z16_QUANT
				M->Z11_IIVLR        := ( aZ11Imp[nPosZ11,31] / aZ11Imp[nPosZ11,2]) * Z16->Z16_QUANT
				M->Z11_IIIOF        := ( aZ11Imp[nPosZ11,32] / aZ11Imp[nPosZ11,2]) * Z16->Z16_QUANT
				
			ENDIF 
	
			DBSELECTAREA("Z11")
			RECLOCK("Z11",.T.)
	
			For nY := 1 To Z11->( FCOUNT())
				FieldPut( nY, M->&( FieldName(nY)))
			Next nY	  
	
			Z11->( MSUNLOCK())
			

			
			 
			
			
			
			/*----------------------------------------
				07/06/2019 - Jonatas Oliveira - Compila
				Atualiza o Item do Rateio
			------------------------------------------*/
			Z16->( RecLock("Z16",.F.) )
				Z16->Z16_ITXML := nItem				
			Z16->( MsUnLock() )
			
			nF1FORNECE	:= aScan(aF1Cabec,{|x| ALLTRIM(x[1])=="F1_FORNECE"})
			nF1LOJA		:= aScan(aF1Cabec,{|x| ALLTRIM(x[1])=="F1_LOJA"}) 
			
			cFornece	:= aF1Cabec[nF1FORNECE,2] 
			cLjForne	:= aF1Cabec[nF1LOJA,2] 
			
			nRecSA5		:= ProdFor( Z16->Z16_CODPRO, cFornece , cLjForne )								
	
			IF nRecSA5 == 0
						
				DBSELECTAREA("SA5")
				SA5->(DBSETORDER(1))
				
				RECLOCK("SA5",.T.)
				
					SA5->A5_FORNECE		:= cFornece		
					SA5->A5_LOJA		:= cLjForne
					SA5->A5_NOMEFOR		:= POSICIONE("SA2",1 , cFornece + cLjForne , "A2_NOME")
					SA5->A5_PRODUTO		:= Z16->Z16_CODPRO
					SA5->A5_CODPRF		:= Z16->Z16_CODPRO
				
				MSUNLOCK()
			ENDIF 
		Next nZ
		
		Z11->(DBGOTOP())
		Z11->(DBSEEK(cChvZ11))
		
		WHILE Z11->(!EOF()) .AND. cChvZ11 == Z11->( Z11_FILIAL + Z11_CHVNFE + Z11_TIPARQ )
			
			nRecSA5		:= ProdFor( Z16->Z16_CODPRO, cFornece , cLjForne )
			
			IF nRecSA5 == 0
						
				DBSELECTAREA("SA5")
				SA5->(DBSETORDER(1))
				
				RECLOCK("SA5",.T.)
				
					SA5->A5_FORNECE		:= cFornece		
					SA5->A5_LOJA		:= cLjForne
					SA5->A5_NOMEFOR		:= POSICIONE("SA2",1 , cFornece + cLjForne , "A2_NOME")
					SA5->A5_PRODUTO		:= Z11->Z11_CODPRO
					SA5->A5_CODPRF		:= Z11->Z11_CODPRO
				
				MSUNLOCK()
			ENDIF 
			
			Z11->(DBSKIP())
		ENDDO
		
	ENDIF 
 		
		
Return()




/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ProdFor  ºAutor  ³ Augusto Ribeiro	 º Data ³  24/04/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna Recno do SA5 posicionado no Produto correto        º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ProdFor(cProdFor, cCodFor, cLojaFor)
Local nRet 	:= 0
Local cQuery := ""

	cQuery := " SELECT R_E_C_N_O_  AS SA5_RECNO"
	cQuery += " FROM "+RetSQLName("SA5")+" SA5 "
	cQuery += " WHERE A5_FILIAL = '"+xfilial("SA5")+"' "
	cQuery += " AND A5_CODPRF = '"+alltrim(cProdFor)+"' "
	cQuery += " AND A5_FORNECE = '"+cCodFor+"' "
	cQuery += " AND A5_LOJA = '"+cLojaFor+"' "
	cQuery += " AND SA5.D_E_L_E_T_ = '' " 
	cQuery += " ORDER BY R_E_C_N_O_ "
	
	MemoWrite(GetTempPath(.T.) + "ProdFor"+ STRTRAN(TIME(),":","") +".SQL", cQuery) 

	cQuery	:= ChangeQuery(cQuery)
	
	TcQuery cQuery New Alias "TSA5"	                  
	
	IF TSA5->(!EOF())
		nRet	:= TSA5->SA5_RECNO
	ENDIF	
	
	TSA5->(DBCLOSEAREA())      
Return(nRet)


/*/{Protheus.doc} CP0114CH
Atualiza Lista de NF devolução
@author Augusto Ribeiro | www.compila.com.br
@since 19/02/2020
@version undefined
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function CP0114CH()
Local nX, nI


FOR nX := 1 to len(aDadoPC)	
	aDadoPC[nX,1]			:= .F.
	aDadoPC[nX,nQTDEDEV]	:= 0

NEXT

nI := oLbxNF:nAt
IF !EMPTY(aDadoNF[nI, nDEVXNFS])
	FOR nX := 1 TO  LEN(aDadoNF[nI,nDEVXNFS])
		oLbxPC:nAt	:= aDadoNF[nI,nDEVXNFS,nX,1]
		//IF aDadoNF[nI,nDEVXNFS,nX,1] == oLbxPC:nAt
		aDadoPC[oLbxPC:nAt,1]			:= .T.
		aDadoPC[oLbxPC:nAt,nQTDEDEV]	:= aDadoNF[nI,nDEVXNFS,nX,2]
		oLbxPC:nAt	:= 1
		
		//ENDIF
	NEXT
ENDIF


Return()



/*/{Protheus.doc} MontaSD1
Monta ARRAY SD1 com base no itens selecionados.
@author Augusto Ribeiro | www.compila.com.br
@since 20/02/2020
@version version
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function MontaSD1()
Local nI, nX
lOCAL cCFOPEXP
Local aItensNFe	:= {}
Local aLinhaNfe	:= {}
lOCAL cCFOPEXP, aCFOPEXP


//							1 			2         3
// nDEVXNFS | |aAux	:= {oLbxPC:nAt, nQtdCons, aVetor[oLbxPC:nAt, nSD2RECNO] } //| {nPoscao NFS, nQtdeUsada, nRecSD2}  Dados Gravados no Array NF Devolucao |

//cSerie, cCliFor, cLoja // ### RECEBER VIA PARAMETRO

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Converte CFOP de Saida para Entrada ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								
DBSELECTAREA("SD2")
FOR nI := 1 TO LEN(aDadoNF)
	IF !EMPTY(aDadoNF[nI,nDEVXNFS])
		aLinhaNfe	:= {}
		FOR nX := 1 TO  LEN(aDadoNF[nI,nDEVXNFS])
			
			//| Posiciona nos itens da XML |
			Z11->(DBGOTO(aDadoNF[nI,nZ11RECNO]))
			
			//| Posiciona no Itens da NF de Origem|
			SD2->(DBGOTO(aDadoNF[nI,nDEVXNFS,nX,3]))

		   	AADD(aLinhaNfe, {"D1_FILIAL"	,XFILIAL('SD1')		  		,NIL}) 
		 	AADD(aLinhaNfe, {"D1_DOC"		,Z10->Z10_NUMNFE  			,NIL}) 
		   	AADD(aLinhaNfe, {"D1_SERIE"		,cSerXML						,NIL}) 
			AADD(aLinhaNfe, {"D1_FORNECE"	,cCliXML					,NIL}) 
			AADD(aLinhaNfe, {"D1_LOJA"		,cLjXML						,NIL})

			AADD(aLinhaNfe, {"D1_COD" 		,SD2->D2_COD				,NIL})
			
			cCFOP	:= Z11->Z11_CFOP
			cCFOP	:= U_CP0102CF(cCFOP)				   
			AADD(aLinhaNfe, {"D1_CF" 		,cCFOP						,NIL})
			
			AADD(aLinhaNfe, {"D1_QUANT"		,aDadoNF[nI,nDEVXNFS,nX,2]					,NIL})
			AADD(aLinhaNfe, {"D1_VUNIT"		,Z11->Z11_VLRUNI			,NIL}) 
			AADD(aLinhaNfe, {"D1_TOTAL"		,Z11->Z11_VLRUNI*aDadoNF[nI,nDEVXNFS,nX,2]					,NIL}) 

			AADD(aLinhaNfe,{"D1_NFORI"		, SD2->D2_DOC , nil }) 
			AADD(aLinhaNfe,{"D1_SERIORI"	, SD2->D2_SERIE , nil })
			AADD(aLinhaNfe,{"D1_ITEMORI"	, SD2->D2_ITEM , nil })	

			//ÚÄÄÄÄÄÄÄÄÄÄ¿
			//³ IMPOSTOS ³
			//ÀÄÄÄÄÄÄÄÄÄÄÙ
			//ÚÄÄÄÄÄÄ¿
			//³ ICMS ³
			//ÀÄÄÄÄÄÄÙ
			IF Z11->Z11_ICVLR > 0
				AADD(aLinhaNfe, {"D1_BASEICM"	,Z11->Z11_ICBC	,NIL})
				AADD(aLinhaNfe, {"D1_PICM"		,Z11->Z11_ICALQ	,NIL})
				AADD(aLinhaNfe, {"D1_VALICM"	,Z11->Z11_ICVLR	,NIL})
			ENDIF    
			                

			//ÚÄÄÄÄÄ¿
			//³ IPI ³
			//ÀÄÄÄÄÄÙ
			IF Z11->Z11_IPIVLR > 0						
				AADD(aLinhaNfe, {"D1_BASEIPI"	,Z11->Z11_IPIBC 	,NIL})
				AADD(aLinhaNfe, {"D1_IPI"		,Z11->Z11_IPIALQ	,NIL})
				AADD(aLinhaNfe, {"D1_VALIPI"	,Z11->Z11_IPIVLR	,NIL})
				ENDIF 

   
				AADD(aLinhaNfe, {"D1_XITEXML"		,Z11->Z11_ITEM		,NIL}) 
			AADD(aLinhaNfe, {"D1_XORIXML"		,Z11->Z11_ICORIG	,NIL}) // campo customizado origem Gomes da Costa
			cCFOPEXP	:= ALLTRIM( U_CP01005G("11", "CFOPEXP") )
			
			If !EMPTY(cCFOPEXP) 
				aCFOPEXP := U_cpC2A(cCFOPEXP, "/")
				
				IF ASCAN( aCFOPEXP, RIGHT( alltrim(cCFOP),3) ) > 0 
					AADD(aLinhaNfe, {"D1_XEANTRB"	,Z11->Z11_EANTRB	,NIL})
					AADD(aLinhaNfe, {"D1_XUTRIB"	,Z11->Z11_UTRIB		,NIL})
					AADD(aLinhaNfe, {"D1_XQTRIB"	,Z11->Z11_QTRIB		,NIL})
					AADD(aLinhaNfe, {"D1_XVUNTIB"	,Z11->Z11_VUNTIB	,NIL})								
				ENDIF 
			EndIf
			

			
			aadd(aItensNFe, ACLONE(aLinhaNfe))
		NEXT
	ENDIF
NEXT						
	

Return(aItensNFe)





