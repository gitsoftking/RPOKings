#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.ch"
#INCLUDE "TopConn.ch" 

#DEFINE EOL			chr(13)+chr(10) 

Static cTitulo	:= "Pedido de Compra"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CP01006  บAutor  ณ Augusto Ribeiro	 บ Data ณ  22/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Interface para selecao do Ped. Compra com o Danfe Importadaบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/  
User Function CP01006(aSF1Cab, aSF1Itens, aProdNCM)
Local _lProcess		:= .F.       
Local cQuery		:= ""  
Local _aSay			:= {}
Local _aBotoes		:= {}
Local nY, aRet		:= {} 
 
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณNecessario INCLI = .F. para evitar Loop automatico da funcao  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local lInc			:= INCLUI         
INCLUI				:= .F.
         
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
	
IF LEN(aSF1Cab) > 0 .AND. LEN(aSF1Itens) > 0
                 
	PRIVATE aF1Cabec 		:= aSF1Cab
	PRIVATE aF1Itens		:= aSF1Itens
	PRIVATE aPrdNCM			:= aProdNCM
	
	nF1FORNECE	:= aScan(aF1Cabec,{|x| ALLTRIM(x[1])=="F1_FORNECE"})
	nF1LOJA		:= aScan(aF1Cabec,{|x| ALLTRIM(x[1])=="F1_LOJA"}) 
	

	aRet	:= fDialogo()		
ENDIF
	 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Restaura INCLUI ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
INCLUI := lInc
		
Return(aRet)

             

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fDialogo บAutor  ณ Augusto Ribeiro	 บ Data ณ  10/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Monta Dialogo                                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function fDialogo()  
Local aRet	:= {}
Local bOK		
Local bCanc		
//Local bRat
Local aButtons	:= {}   
Local oFLabels := TFont():New("MS Sans Serif",,026,,.F.,,,,,.F.,.T.)
                     
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis de posionamento dos campos ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private nNFSALDO, nNFD1COD, nNFD1QUANT
//incluํda linha abaixo [Mauro Nagata, www.compila.com.br, 20200308]
Private nNFD1VUNIT
Private nPC7NUM, nPC7ITEM, nPC7PRECO, nPC7PRODUTO, nPC7QUANT, nPSALDO, nPC7RECNO

Private oDlgPed	:= NIL
Private aSizePed, aObjects, aInfo, aPosObj, aPosEnc
                
//bOK		:= {|| ListNF("A",@oLbxNF,@aHeadNF, @aDadoNF), oLbxNF:Refresh() } //{|| oDlgPed:End()}
//bRat		:= {|| oDlgPed:End()} 	
bCanc		:= {|| oDlgPed:End()} 	
bOK			:= {|| ConfPc(@oDlgPed, @aRet)}
aButtons	:= {}
//aAdd(aButtons	,{"ENABLE" ,{|| U_CP0106R() },"Manutencao de Itens","Manutencao de Itens" })

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDimensionamento da Janela - Parte Superior ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aSizePed	:= MsAdvSize()		
aObjects	:= {}
 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Caso chamada da funcao tenha sito feita pelo botao consultar log ณ
//ณ Redimenciona tela para melhor visualizacao                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAdd( aObjects, {50,50, .T., .T.} )	
aAdd( aObjects, { 100, 100, .T., .T., .T.} )

aInfo := { aSizePed[ 1 ], aSizePed[ 2 ], aSizePed[ 3 ], aSizePed[ 4 ], 3, 3 }
aPosObj 	:= MsObjSize( aInfo, aObjects, .T. )                                                                         

aPosObj[1,1]	+= 12


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Dimensionamento da Janela - Parte Inferior ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aInfo := { aPosObj[2,2], aPosObj[2,1]+40, aPosObj[2,3], aPosObj[2,4]-30, 8, 3 }

aObjects	 := {}
aAdd( aObjects, { 100, 100, .T., .T.} )	

aPosObj2	:= MsObjSize( aInfo, aObjects, .T. , .T. )
     
aPosObj2[1,2] -= 8            

aPosEnc	:= {000,000,aPosObj[1,3]-aPosObj[1,1]-12,aPosObj[1,4]-aPosObj[1,2]-1}
		   

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta Dialog ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DEFINE MSDIALOG oDlgPed TITLE cTitulo FROM aSizePed[7],00 to aSizePed[6],aSizePed[5] OF oMainWnd PIXEL		

@ aPosObj[1,1]-12, aPosObj[1,2] SAY oLblSolicita PROMPT "Nota Fiscal" SIZE 131, 014 OF oDlgPed FONT oFLabels COLORS 128, 16777215 PIXEL
//@ aPosObj2[1,1]-12,aPosObj2[1,2] SAY oLblPoint PROMPT "Pedido de Compra" SIZE 131, 014 OF oDlgPed FONT oFLabels COLORS 128, 16777215 PIXEL
//substituํda linha acima pela abaixo [Mauro Nagata, Compila, 20200215]
@ aPosObj2[1,1],aPosObj2[1,2] SAY oLblPoint PROMPT "Pedido de Compras" SIZE 131, 014 OF oDlgPed FONT oFLabels COLORS 128, 16777215 PIXEL
          
//ฺฤฤฤฤฤฤฤฤฟ
//ณ BOTOES ณ
//ภฤฤฤฤฤฤฤฤู
//oSCVisual		:= TButton():New(aPosObj[1,1]-12, aPosObj[1,4]-150,"Visualizar",oDlgPed,		{|| MSGRUN("Solicita็ใo de Compras", "Aguarde...", {|| VisualSC(aDadoNF, oLbxNF:nAt)}) },045,010,,,,.T.,,"Visualizar Solicita็ใo de Compras",,,,.F. )
//oSCAprov		:= TButton():New(aPosObj[1,1]-12, aPosObj[1,4]-100,"Aprovar",oDlgPed,		{|| U_ACOM06SC("A",aDadoNF),  ListNF("A",@oLbxNF,@aHeadNF, @aDadoNF), oLbxNF:Refresh() },045,010,,,,.T.,,"Aprovar Solicita็ใo de Compras",,,,.F. )
//oSCReprov		:= TButton():New( aPosObj[1,1]-12, aPosObj[1,4]-50,"Reprovar",oDlgPed,	{|| U_ACOM06SC("R",aDadoNF), ListNF("A",@oLbxNF,@aHeadNF, @aDadoNF), oLbxNF:Refresh() },045,010,,,,.T.,,"Reprovar Solicita็ใo de Compras",,,,.F. )


oPCVisual		:= TButton():New(aPosObj2[1,1]-12, aPosObj[1,4]-150,"Visualizar",oDlgPed,		{|| MSGRUN("Pedido de Compras", "Aguarde...", {|| VisualPC(aDadoPC, oLbxPC:nAt)}) },045,010,,,,.T.,,"Visualizar Pedido de Compras",,,,.F. )
//oPCAprov		:= TButton():New(aPosObj2[1,1]-12, aPosObj[1,4]-100,"Aprovar",oDlgPed,	{|| U_ACOM06PC("A",aDadoPC), ListPC("A",@oLbxPC,@aHeadPC, @aDadoPC), oLbxNF:Refresh() },045,010,,,,.T.,,"Aprovar Pedido de Compras",,,,.F. )
//oPCReprov		:= TButton():New( aPosObj2[1,1]-12, aPosObj[1,4]-50,"Reprovar",oDlgPed,{|| U_ACOM06PC("R",aDadoPC), ListPC("A",@oLbxPC,@aHeadPC, @aDadoPC), oLbxNF:Refresh() },045,010,,,,.T.,,"Reprovar Pedido de Compras",,,,.F. )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta List Solicitacao de Compras ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 
Private aHeadNF	:= {}       
Private aDadoNF	:= {}
Private oLbxNF	:= Nil            

ListNF("C",@oLbxNF,@aHeadNF, @aDadoNF)  
      
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta List Pedido de Compra       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 
Private aHeadPC	:= {}       
Private aDadoPC	:= {}
Private oLbxPC	:= Nil            

ListPC("C",@oLbxPC,@aHeadPC, @aDadoPC) 

//|oLbxPC:BHEADERCLICK	:= { |oObj,nCol| U_cpHeadOrd( oObj,nCol, .T.) }

//oLbxNF:bChange := {|| U_CCOM02LP("A",aDadoNF[oLbxNF:nAt, nSC1NUM],@oLbxPC,@aHeadPC, @aDadoPC), ListLog("A",@oLbxLog,@aHeadLog, @aDadoLog), oLbxPC:Refresh() }

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
Tratativa para o botใo Salvar(Confirmar)
@author Jonatas Oliveira | www.compila.com.br
@since 23/07/2019
@version 1.0
/*/
Static Function ConfPc(oDlgPed, aRet)
//incluํda linha abaixo [Mauro Nagata, www.compila.com.br, 20200227]
Local lSucesso := .T.
	
//incluํdo bloco abaixo [Mauro Nagata, Compila, 20200213]
//todos os itens da nota fiscal deveriam estar zerados

For nI := 1 To Len(aDadoNF)
	If aDadoNF[nI,nNFSaldo] <> 0
		lSucesso := .F.
	EndIf
Next
	
If lSucesso
//fim bloco [Mauro Nagata, Compila, 20200213]
	For nI := 1 To Len(aDadoPC)
	            
		If aDadoPC[nI,1]
			aadd(aRet, aDadoPC[nI,nPC7RECNO])
		EndIf
		
	Next nI
	
	oDlgPed:End()
//incluํda linha abaixo [Mauro Nagata, Compila, 20200213]
Else
	MsgBox("Nem todos os itens da nota fiscal foram atendidos","Aten็ใo!","STOP")
EndIf
	
Return()




/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ListNF   บAutor  ณ Augusto Ribeiro	 บ Data ณ  10/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  List Solicitacao de Compras                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function ListNF(cOpcList,oLbxNF,aHeader, aDados)
Local lRet		:= .T.
Local cQuery	:= "" 
Local aCpoHeader, aLinha
Local cBCodLin	:= ""
Local nI, nY
     
aCpoHeader	:= {} 
aHeader		:= {} 
                      
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta aHeader ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 
aadd(aHeader," ")
aadd(aCpoHeader," ")          

aadd(aCpoHeader,"SALDO")	;	nNFSALDO	:= 2
aadd(aCpoHeader,"D1_COD")	;	nNFD1COD	:= 3
aadd(aCpoHeader,"B1_DESC")
aadd(aCpoHeader,"D1_UM")
aadd(aCpoHeader,"D1_QUANT")	;	nNFD1QUANT	:= 6
aadd(aCpoHeader,"D1_VUNIT")	
//incluํda linha abaixo [Mauro Nagata, www.compila.com.br, 20200308]
nNFD1VUNIT	:= 7
aadd(aCpoHeader,"D1_TOTAL")

For nY := 2 To LEN(aCpoHeader) 
	IF nY == nNFSALDO
	   	aadd(aHeader,"Saldo")	
	ELSE
	   	aadd(aHeader,ALLTRIM(RetTitle(aCpoHeader[nY])))
	ENDIF
Next nY	


DbSelectArea("SB1")
SB1->(DBSETORDER(1))
                  
                         
aDados		:= {}
FOR nI := 1 to len(aF1Itens)
	aLinha	:= {}     

	 
	
	nD1COD		:= aScan(aF1Itens[nI],{|x| ALLTRIM(x[1])=="D1_COD"})	
	nD1QUANT	:= aScan(aF1Itens[nI],{|x| ALLTRIM(x[1])=="D1_QUANT"})	
	nD1VUNIT	:= aScan(aF1Itens[nI],{|x| ALLTRIM(x[1])=="D1_VUNIT"})	
	nD1TOTAL	:= aScan(aF1Itens[nI],{|x| ALLTRIM(x[1])=="D1_TOTAL"})	

	DBSEEK(XFILIAL("SB1")+aF1Itens[nI, nD1COD, 2])
		
	AADD(aLinha, .F.)
	aadd(aLinha,  aF1Itens[nI, nD1QUANT, 2])	
	aadd(aLinha,  aF1Itens[nI, nD1COD, 2])	
	aadd(aLinha,  ALLTRIM(SB1->B1_DESC))
	aadd(aLinha,  ALLTRIM(SB1->B1_UM))                              
	aadd(aLinha,  aF1Itens[nI, nD1QUANT, 2] )
	aadd(aLinha,  transform(aF1Itens[nI, nD1VUNIT, 2], PESQPICT("SD1","D1_VUNIT")) )
	aadd(aLinha,  transform(aF1Itens[nI, nD1TOTAL, 2], PESQPICT("SD1","D1_TOTAL")) )

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Carrega lista de produtos existentes na NF ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	IF ASCAN(aProdNF, aF1Itens[nI, nD1COD, 2]) == 0
		AADD(aProdNF, ALLTRIM(aF1Itens[nI, nD1COD, 2]))	
	ENDIF		
	
	AADD(aDados, aLinha)	
NEXT nI




//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ cOpcList | C = Cria, A = Atualiza ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
IF cOpcList == "C"

	@ aPosObj[1,1],aPosObj[1,2] LISTBOX oLbxNF FIELDS HEADER ;
	   " ", "Campos" ;                                                                                                    
	   SIZE aPosObj[1,4],aPosObj[1,3] OF oDlgPed PIXEL 
ENDIF

oLbxNF:aheaders := aHeader
oLbxNF:SetArray( aDados )  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria string com Bloco de Codigo ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//cBCodLin	:= "Iif(aDados[oLbxNF:nAt,1],oVerde,oVermelho)"

cBCodLin	:= "Iif( aDados[oLbxNF:nAt,nNFSALDO] == 0, oVerde, IIF(aDados[oLbxNF:nAt,nNFSALDO] == aDados[oLbxNF:nAt,nNFD1QUANT], oVermelho, oAmarelo ) )"

For nI := 2 To LEN(aHeader)
	IF nI > 1
		cBCodLin	+=", "
	endif
   cBCodLin	+= "aDados[oLbxNF:nAt,"+alltrim(str(nI))+"]"
Next nI	

cBCodLin	:= "oLbxNF:bLine := {|| {"+cBCodLin+"}}"
&(cBCodLin)

Return(lRet)
       



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ListPC   บAutor  ณ Augusto Ribeiro	 บ Data ณ  10/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  List Solicitacao de Compras                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function ListPC(cOpcList,oLbxPC,aHeader, aDados)
Local lRet		:= .T.
Local cQuery	:= "" 
Local aCpoHeader, aLinha
Local cBCodLin	:= ""
     
aCpoHeader	:= {} 
aHeader		:= {} 
aDados		:= {}

//excluํda linha abaixo [Mauro Nagata, www.compila.com.br, 20200306]
//incluํda linha abaixo [Mauro Nagata, www.compila.com.br, 20200303]
//desconsiderar pedido de compras onde o pre็o unitแrio do pedido de compras
//for menor que o valor unitแrio da nota fiscal
//especํfico GDC
//nVlrF1It := aScan(aF1Itens[1],{|x| x[1] == "D1_VUNIT"})

cQuery	:= " SELECT C7_EMISSAO, "+EOL	
cQuery	+= " 		C7_NUM, "+EOL	
cQuery	+= " 		C7_ITEM, "+EOL	
cQuery	+= " 		C7_PRODUTO, "+EOL	
cQuery	+= " 		B1_DESC,  "+EOL	
cQuery	+= " 		C7_QUANT,	 "+EOL	
cQuery	+= " 		C7_PRECO,	 "+EOL	
cQuery	+= " 		C7_TOTAL, "+EOL	
cQuery	+= " 		(C7_QUANT-C7_QUJE-C7_QTDACLA) AS SALDO, "+EOL	
cQuery	+= " 		SC7.R_E_C_N_O_ AS SC7_RECNO "+EOL			
cQuery	+= " FROM "+RetSQLName("SC7")+" SC7  "+EOL	
cQuery	+= " INNER JOIN "+RetSQLName("SB1")+" SB1 " + EOL	
cQuery	+= " 		ON 	B1_FILIAL 			= '" + XFILIAL("SB1") + "' " + EOL	
cQuery	+= " 			AND B1_COD 			= C7_PRODUTO " + EOL
cQuery	+= " 			AND SB1.D_E_L_E_T_	= '' " + EOL	
cQuery	+= " WHERE 	C7_FILIAL = '"+XFILIAL("SC7")+"'  " + EOL	
cQuery	+= " 		AND C7_FORNECE 		= '"+aF1Cabec[nF1FORNECE,2]+"'  " + EOL	
cQuery	+= " 		AND C7_LOJA 		= '"+aF1Cabec[nF1LOJA,2]+"'  " + EOL 
cQuery	+= " 		AND C7_PRODUTO IN "+U_cpINQry(aProdNF) + EOL
cQuery	+= " 		AND (C7_QUANT-C7_QUJE-C7_QTDACLA) > 0  " + EOL	
cQuery	+= " 		AND SC7.D_E_L_E_T_ 	= ''  " + EOL	
cQuery	+= " 		AND C7_CONAPRO		= 'L'  " + EOL	
cQuery	+= " 		AND C7_RESIDUO 		<> 'S'  " + EOL	
cQuery	+= " 		AND C7_ENCER 		<> 'E' "+ EOL

//excluํda linha abaixo [Mauro Nagata, www.compila.com.br, 20200306]
//em reuniใo com a GDC foi definido que deve ser apresentado o pedido de compras
//que nใo atenda a regra para gerar o documento de entrada, 
//por้m para o processo operacional ้ necessแrio a presen็a do pedido de compras 
//que nใo atenda a regra para que o colaborador tenha ci๊ncia que existe um pedido
//de compras e por que nใo atende as regras
//incluํda linha abaixo [Mauro Nagata, www.compila.com.br, 20200303]
//cQuery	+= "		AND C7_PRECO >= " + Str(aF1Itens[1][nVlrF1It][2]) + " " + EOL
	
cQuery	+= " ORDER BY C7_EMISSAO, C7_NUM, C7_ITEM  " + EOL	

If Select("TPC") > 0
	TPC->(DbCloseArea())
EndIf
          
//cQuery	:= ChangeQuery(cQuery)
//substituํda linha acima pela abaixo [Mauro Nagata, www.compila.com.br, 20200308]
cQuery	:= cQuery
                   
MSGRUN("Aguarde....","SQL" ,		{|| dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),'TPC') } )					

TCSetField("TPC","C7_EMISSAO","D",08,00) 


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta aHeader ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู   
aadd(aHeader," ")                
aadd(aCpoHeader," ")
For nY := 1 To TPC->(FCOUNT())
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

nPC7NUM		:= Ascan(aCpoHeader,"C7_NUM")
nPC7ITEM	:= Ascan(aCpoHeader,"C7_ITEM")
nPC7PRECO	:= Ascan(aCpoHeader,"C7_PRECO")
nPC7PRODUTO	:= Ascan(aCpoHeader,"C7_PRODUTO")
nPC7QUANT	:= Ascan(aCpoHeader,"C7_QUANT")
nPSALDO		:= Ascan(aCpoHeader,"SALDO")
nPC7RECNO	:= Ascan(aCpoHeader,"SC7_RECNO")
					

IF TPC->(!EOF()) 			
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta aDados ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	WHILE TPC->(!EOF())
		
		/*
		//incluํdo bloco abaixo [Mauro Nagata, www.compila.com.br, 20200303]
		//desconsiderar pedido de compras onde o pre็o unitแrio do pedido de compras
		//for menor que o valor unitแrio da nota fiscal
		//especํfico GDC
		nVlrF1It := aScan(aF1Itens[1],{|x| x[1] == "D1_VUNIT"})
		
		If TPC->C7_PRECO < aF1Itens[1][nVlrF1It][2]
			TPC->(DbSkip())
			Loop
		EndIf
		//fim bloco [Mauro Nagata, www.compila.com.br, 20200303]
		*/
		aLinha	:= {}
		AADD(aLinha, .F.)
		For nY := 1 To TPC->(FCOUNT())

			IF VALTYPE(TPC->&(FieldName(nY))) == "C"     
			
				aadd(aLinha, ALLTRIM(TPC->&(FieldName(nY))) )
			ELSE                                              				
				aadd(aLinha, TPC->&(FieldName(nY)) )
			ENDIF
		Next nY	 
		
		AADD(aLinha,{})
		
	 	AADD(aDados, aLinha)
	 	
		TPC->(DBSKIP())
	ENDDO  
	
ELSE
	aLinha	:= {}   
	AADD(aLinha, .F.)	
	For nY := 1 To TPC->(FCOUNT())          
		IF ALLTRIM(FieldName(nY)) == "SALDO" .OR. ALLTRIM(FieldName(nY)) == "SC7_RECNO"     
			aadd(aLinha, 0 )		
		ELSE
			aadd(aLinha, CRIAVAR(FieldName(nY),.F.) )
		ENDIF
	Next nY	 
	
	AADD(aLinha,{})
	
 	AADD(aDados, aLinha)
ENDIF                     
	     
	
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ cOpcList | C = Cria, A = Atualiza ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
IF cOpcList == "C"

	@ aPosObj2[1,1]+14,aPosObj2[1,2] LISTBOX oLbxPC FIELDS HEADER ;
	   " ", "Campos" ;                                                                                                    
	   SIZE aPosObj2[1,4],aPosObj2[1,3] OF oDlgPed PIXEL ON dblClick(MarkPC(@aDados),oLbxPC:Refresh())   //ON dblClick(VisualSC(aDadoNF, oLbxPC:nAt))
	   
ENDIF

oLbxPC:aHeaders := aHeader
oLbxPC:SetArray( aDados )  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria string com Bloco de Codigo ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ VisualPC บAutor  ณAugusto Ribeiro     บ Data ณ 19/08/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Visualiza a Pedido de Compras                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
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
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ O parametro MV_VLDHEAD e' usado para validar ou nao o aCols          ณ
//ณ (uma linha ou todo), a partir das validacoes do aHeader -> VldHead() ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Chama Visualiza็ใo da rotina padrao ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	A120Pedido(,,2)
ENDIF

Return       
      
      

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ MarkPC   บAutor  ณAugusto Ribeiro     บ Data ณ 22/08/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Marca todos os itens da mesma solicitacao de compras       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function MarkPC(aVetor)
  
Local nX,nAux, nSaldoPed
//incluํda linha abaixo [Mauro Nagata, www.compila.com.br, 20200308]
Local cAtencao := ""
                  
	aVetor[oLbxPC:nAt,1]	:= Iif(aVetor[oLbxPC:nAt,1],.F.,.T.)
    
    nSaldoPed := 0    
       
    //llFlag	:= .F.    
    //substitutํda linha acima pela abaixo [Mauro Nagata, www.compila.com.br, 20200308]
    llFlag := .T.
    
    For nY := 1 To Len(aDadoNF)
    
    	/*
    	IF ALLTRIM(aDadoNF[nY, nNFD1COD]) == ALLTRIM(aVetor[oLbxPC:nAt, nPC7PRODUTO])
    	
    		IF aDadoNF[nY, nNFSALDO] <= 0
    			llFlag := .T.
    		ENDIF
    	ENDIF
    	*/
    	//substitutํdo bloco acima pelo abaixo [Mauro Nagata, www.compila.com.br, 20200308]
    	If AllTrim(aDadoNF[nY, nNFD1COD]) == AllTrim(aVetor[oLbxPC:nAt, nPC7PRODUTO])
    		
    		If aVetor[oLbxPC:nAt,1]		//item do pedido de compras foi selecionado 
    		
    			//quando nใo tiver saldo da nota fiscal 
	    		//If aDadoNF[nY, nNFSALDO] <= 0
	    		//substitutํdo bloco acima pelo abaixo [Mauro Nagata, www.compila.com.br, 20200308]
	    		If aDadoNF[nY, nNFSALDO] <= 0 //.Or. aDadoNF[nY, nNFSALDO] -  aVetor[oLbxPC:nAt, nPSALDO] < 0
	    			llFlag := .F.
	    			cAtencao += "INCONSISTENTE O saldo da nota fiscal ้ insulficiente para atender este Item do pedido" + CRLF 
	    			cAtencao += "   Produto NF: " + AllTrim(aDadoNF[nY, nNFD1COD]) + "     Pedido/Item: " + aVetor[oLbxPC:nAt, nPC7NUM] + " / " + aVetor[oLbxPC:nAt, nPC7ITEM] + CRLF 	 
	    			cAtencao += "   Saldo Item NF: " + Transform(aDadoNF[nY, nNFSALDO],"@E 999,999.999") 
	    			cAtencao += "     PC: " + Transform(aVetor[oLbxPC:nAt, nPSALDO],"@E 999,999.999") 
	    			//cAtencao += "     #" + Transform(aDadoNF[nY, nNFSALDO] -  aVetor[oLbxPC:nAt, nPSALDO],"@E 999,999.999") + CRLF + CRLF
	    			//substiuํda linha acima pela abaixo [Mauro Nagata, www.compila.com.br, 20200311]
	    			cAtencao += "     Diferen็a:" + Transform(aDadoNF[nY, nNFSALDO] -  aVetor[oLbxPC:nAt, nPSALDO],"@E 999,999.999") + CRLF + CRLF
	    		EndIf
	    		
	    		//valor unitแrio da nota fiscal tem que ser menor ou igual ao valor do pedido de compras - GDC
	    		If Val(StrTran(StrTran(aDadoNF[nY, nNFD1VUNIT],".",""),",",".")) > aVetor[oLbxPC:nAt, nPC7PRECO]		
	    			llFlag := .F.
	    			cAtencao += "INCONSISTENTE Valor ๚nitแrio da nota fiscal ้ maior que o valor do pedido de compras" + CRLF
	    			cAtencao += "   Produto NF: " + AllTrim(aDadoNF[nY, nNFD1COD]) + "     Pedido/Item: " + aVetor[oLbxPC:nAt, nPC7NUM] + " / " + aVetor[oLbxPC:nAt, nPC7ITEM] + CRLF
	    		EndIf
	    		
	    		//notificar se o valor unittแrio da nota fiscal for menor que o valor do pedido de compras - GDC
	    		If Val(StrTran(StrTran(aDadoNF[nY, nNFD1VUNIT],".",""),",",".")) < aVetor[oLbxPC:nAt, nPC7PRECO]
	    			cAtencao += "ALERTA Valor ๚nitแrio da nota fiscal ้ menor que o valor do pedido de compras" + CRLF
	    			cAtencao += "   Produto NF: " + AllTrim(aDadoNF[nY, nNFD1COD]) + "     Pedido/Item: " + aVetor[oLbxPC:nAt, nPC7NUM] + " / " + aVetor[oLbxPC:nAt, nPC7ITEM] + CRLF + CRLF
	    		EndIf
	    	
    		EndIf
    	EndIf
    	//fim bloco [Mauro Nagata, www.compila.com.br, 20200308]
    		
    Next 
    
    /*
    IF !llFlag .AND. aVetor[oLbxPC:nAt,1]
    	
    	//Aviso("Alert", "Nใo hแ saldo na nota para este Item do pedido.",{"OK"},1)
    	FwHelpShow('SALDO',"SALDO","Nใo hแ saldo na nota para este Item do pedido.","")
    	
		aVetor[oLbxPC:nAt,1]:= .F.
		oLbxNF:Refresh()	
		Return
		
    ENDIF
    */
    //substituํdo bloco acima pelo abaixo [Mauro Nagata, www.compila.com.br, 20200308]
    If aVetor[oLbxPC:nAt,1]
    
    	//notificar se houver alguma particularidade do pedido de compras com o item da nota fiscal 
    	If !Empty(cAtencao) 
    		Aviso("Aten็ใo", cAtencao,{"OK"},2)
    	EndIf
    	
    	//quando tive alguma particularidade que nใo permita selecionar o pedido de compras
    	If !llFlag
			aVetor[oLbxPC:nAt,1] := .F.	//desmarca pedido de compras
			oLbxNF:Refresh()	
			Return
		EndIf
		
    EndIf
    //fim bloco [Mauro Nagata, www.compila.com.br, 20200308]
                      
	///|nSaldoPed	:= aVetor[oLbxPC:nAt, nPSALDO]
	//||llFlag	:= .T.
	FOR nX := 1 to len(aDadoNF)                                                     
	
		IF ALLTRIM(aDadoNF[nX, nNFD1COD]) == ALLTRIM(aVetor[oLbxPC:nAt, nPC7PRODUTO])	
		
			IF aVetor[oLbxPC:nAt,1]
				
				
				IF aVetor[oLbxPC:nAt, nPSALDO] = 0
				
					EXIT
					
				ENDIF
				
				
				IF aDadoNF[nX, nNFSALDO] >= aVetor[oLbxPC:nAt, nPSALDO]
										
					aDadoNF[nX, nNFSALDO]		:= aDadoNF[nX, nNFSALDO] - aVetor[oLbxPC:nAt, nPSALDO]
					
					AADD(aVetor[oLbxPC:nAt, 12],{ alltrim(str(nX))+ aVetor[oLbxPC:nAt, nPC7NUM] + aVetor[oLbxPC:nAt, nPC7ITEM], aVetor[oLbxPC:nAt, nPSALDO]})
					
					aVetor[oLbxPC:nAt, nPSALDO]	:= 0
					
				ELSE
				
					AADD(aVetor[oLbxPC:nAt, 12],{ alltrim(str(nX))+ aVetor[oLbxPC:nAt, nPC7NUM] + aVetor[oLbxPC:nAt, nPC7ITEM],aDadoNF[nX, nNFSALDO]})
													
					aVetor[oLbxPC:nAt, nPSALDO]	:= aVetor[oLbxPC:nAt, nPSALDO] - aDadoNF[nX, nNFSALDO] 
					aDadoNF[nX, nNFSALDO] 		:= 0
					
				ENDIF
				                               
			ELSE
			
				//|llFlag:= .F.
				
				IF  aVetor[oLbxPC:nAt, nPC7QUANT] >=  aDadoNF[nX, nNFD1QUANT]
					
					IF LEN(aVetor[oLbxPC:nAt,12]) >= nX
																									
						nPosAr := Ascan(aVetor[oLbxPC:nAt,12][nX],alltrim(str(nX))+ aVetor[oLbxPC:nAt, nPC7NUM] + aVetor[oLbxPC:nAt, nPC7ITEM])
						
						IF nPosAr > 0
																																		
							aVetor[oLbxPC:nAt, nPSALDO]	+= 	aVetor[oLbxPC:nAt,12][nX][2]
							aDadoNF[nX, nNFSALDO]		:=  aDadoNF[nX, nNFSALDO] + aVetor[oLbxPC:nAt,12][nX][2] //| aDadoNF[nX, nNFD1QUANT]
										
						ENDIF
					
					ENDIF
									
				ELSE                                                      										
												
					aVetor[oLbxPC:nAt, nPSALDO]	:= aVetor[oLbxPC:nAt, nPC7QUANT]
					aDadoNF[nX, nNFSALDO]		+= aVetor[oLbxPC:nAt, nPC7QUANT]
									
				ENDIF												
				
			ENDIF
					
		ELSE
		
			AADD(aVetor[oLbxPC:nAt, 12],{ "",0})
			
		ENDIF		

	NEXT nX
	
	//| Zera O array caso o item do pedido seja desmarcado.
	
	IF !aVetor[oLbxPC:nAt,1]
	
		aVetor[oLbxPC:nAt,12]:= {}
		
	ENDIF
	
	oLbxNF:Refresh()	
	
Return
        
/*/{Protheus.doc} CP0106R
Chamada da rotina de Rateio
@author Jonatas Oliveira | www.compila.com.br
@since 24/04/2019
@version 1.0
/*/        
User Function CP0106R(lPedido)
	Local nPosIt, nPosCd, nPosCf, nPosQt, nPosVu, nPosVT
	Private oLbxTit		:= Nil
	Private aCpoTit		:= {}
	Private aHeadTit	:= {}
	Private aDadoTit	:= {}
	Private	oPanel		:= NIL
	
	Default lPedido	:= .T.
	
//	DBSELECTAREA("Z16")
//	Z16->(DBSETORDER(1))//|Z16_FILIAL, Z16_CHVNFE, Z16_TIPARQ, Z16_ITXML|
//	
//	DBSELECTAREA("Z11")
//	Z11->(DBSETORDER(1))//|Z11_FILIAL, Z11_CHVNFE, Z11_TIPARQ, Z11_ITEM|
//	
//	For nX := 1 To Len(aF1Itens)
//		nPosIt	:= aScan(aF1Itens[nX],{|x| ALLTRIM(x[1])=="D1_XITEXML"})
//		nPosCd	:= aScan(aF1Itens[nX],{|x| ALLTRIM(x[1])=="D1_COD"})
//		nPosCf	:= aScan(aF1Itens[nX],{|x| ALLTRIM(x[1])=="D1_CF"})
//		nPosQt	:= aScan(aF1Itens[nX],{|x| ALLTRIM(x[1])=="D1_QUANT"})
//		nPosVu	:= aScan(aF1Itens[nX],{|x| ALLTRIM(x[1])=="D1_VUNIT"})
//		nPosVT	:= aScan(aF1Itens[nX],{|x| ALLTRIM(x[1])=="D1_TOTAL"})
//		
//		IF Z16->( !DBSEEK( Z10->( Z10_FILIAL + Z10_CHVNFE + Z10_TIPARQ ) +  alltrim(str(aF1Itens[nX][nPosIt][2])) )) 
//			Z11->(DBSEEK(Z10->( Z10_FILIAL + Z10_CHVNFE + Z10_TIPARQ + alltrim(str(aF1Itens[nX][nPosIt][2])) )))
//			
//			RecLock('Z16',.T.)					
//				Z16->Z16_FILIAL 	:= xFilial("Z16")				
//				Z16->Z16_ITXML		:= Z11->Z11_ITEM
//				Z16->Z16_TIPARQ     := Z11->Z11_TIPARQ
//				Z16->Z16_CHVNFE     := Z11->Z11_CHVNFE
//				Z16->Z16_NUMNFE     := Z11->Z11_NUMNFE
//				Z16->Z16_SERIE      := Z11->Z11_SERIE
//				Z16->Z16_CNPJ       := Z11->Z11_CNPJ
//				Z16->Z16_ITEM       := nX
//				Z16->Z16_CODPRO     := aF1Itens[nX][nPosCd][2]
//				Z16->Z16_DESPRO     := ALLTRIM(POSICIONE("SB1",1,XFILIAL("SB1") + aF1Itens[nX][nPosCd][2],"B1_DESC"))
//				Z16->Z16_CFOP       := aF1Itens[nX][nPosCf][2]
//				Z16->Z16_UM         := ALLTRIM(POSICIONE("SB1",1,XFILIAL("SB1") + aF1Itens[nX][nPosCd][2],"B1_UM"))
//				Z16->Z16_QUANT      := aF1Itens[nX][nPosQt][2]
//				Z16->Z16_VLRUNI     := aF1Itens[nX][nPosVu][2]
//				Z16->Z16_VLRTOT     := aF1Itens[nX][nPosVT][2]
//				Z16->Z16_LOTEFO     := Z11->Z11_LOTEFO
//				Z16->Z16_LOTECT     := Z11->Z11_LOTECT
//				Z16->Z16_DTVALI     := Z11->Z11_DTVALI
//			Z16->(MsUnLock())
//			
//		ENDIF 
//	Next nX
	
	FWExecView("Manutencao de Itens",  "CP01013",  4,  /*oDlg*/,  /*bCloseOnOk*/,  /*bOk*/, /* nPercReducao*/, /*aEnableButtons*/,  /*bCancel*/ )
	
	IF lPedido
		oDlgPed:End()
	ENDIF 
	
	ATUMODEL()

	U_CP01001C(.F.)
//	oDlgPed
Return()        



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
			------------------------------------------*/
		Next nZ
		/*
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
		*/
	ENDIF 
 		
		
Return()




/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ProdFor  บAutor  ณ Augusto Ribeiro	 บ Data ณ  24/04/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna Recno do SA5 posicionado no Produto correto        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
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