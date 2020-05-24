#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TBICONN.CH" 
#INCLUDE "RPTDEF.CH"
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "FWMBROWSE.CH"      
#INCLUDE 'TBICONN.CH'
#INCLUDE "TOTVS.CH"
#include "fileio.ch"

User Function CP01_TST()
	lOCAL cTeste	:= ''
	lOCAL aTeste	:= {}
	Local lRetAux
	lOCAL oJson, cJson

	//_cEmp		:= "01"
	//_cFilial	:= "00101MG0001" 
	//_cFilial	:= "00201SP0004" //01704BA0001-DELFIN SAJ MEDICOS                      

	_cEmp		:= "02"
	_cFilial	:= "02"

	//aTeste	:= U_CP01API({"02","02"})

	//
	//_cEmp		:= "99"
	//_cFilial	:= "01"
	//
	PREPARE ENVIRONMENT EMPRESA _cEmp FILIAL _cFilial

	//aTeste	:= U_CP01MFXML()
	/*
	aTeste	:= U_CP01MFXML("21207381000154","NFE") //| Centrosucar|
	aTeste	:= U_CP01MFXML("21207381000235","NFE") //| Centrosucar|
	aTeste	:= U_CP01MFXML("21207381000316","NFE") //| Centrosucar|
	*/
	aTeste	:= U_CP01MFXML("14786192000118","NFE") //| tsusho|
	aTeste	:= U_CP01004("DIR")	
	//aTeste	:= U_CP01MFST("61577904000179", "35190439044235000544550020000891361002280740", "INTEGRADO")
	//aTeste	:= U_CP01API({"99","01"})
	//aTeste	:= aTeste
	//
	RESET ENVIRONMENT 

Return

User Function CP01TST2()
	lOCAL cTeste	:= ''
	lOCAL aTeste	:= {}
	Local lRetAux
	lOCAL oJson, cJson

	//_cEmp		:= "01"
	//_cFilial	:= "00101MG0001" 
	//_cFilial	:= "00201SP0004" //01704BA0001-DELFIN SAJ MEDICOS                      

	//_cEmp		:= "01"
	//_cFilial	:= "00101001"


	_cEmp		:= "65"
	_cFilial	:= "01"

	PREPARE ENVIRONMENT EMPRESA _cEmp FILIAL _cFilial

	U_CP01MFXML("21207381000154","NFE") //| Centrosucar|
	U_CP01MFXML("21207381000154","CTE") //| Centrosucar|

	U_CP01MFXML("21207381000235","NFE") //| Centrosucar|
	U_CP01MFXML("21207381000235","CTE") //| Centrosucar|

	U_CP01MFXML("21207381000316","NFE") //| Centrosucar|
	U_CP01MFXML("21207381000316","CTE") //| Centrosucar|

	//aTeste	:= U_CP01MFXML()
	U_CP01004("DIR")

	//aTeste	:= U_CP01MFXML("61577904000179","CTE") //| tsusho|
	//aTeste	:= U_CP01MFST("61577904000179", "35190439044235000544550020000891361002280740", "INTEGRADO")
	//aTeste	:= aTeste

	RESET ENVIRONMENT 

Return


//User Function CP01TST2()
//
//_cEmp		:= "02"
//_cFilial	:= "02"
//
//PREPARE ENVIRONMENT EMPRESA _cEmp FILIAL _cFilial
//	DBSELECTAREA("Z10")
//	Z10->(DBSETORDER(1))
//	Z10->(DBGOTOP())
//	
//	WHILE Z10->(!EOF()) 
//		IF Z10->Z10_STATUS == "1" .AND. Z10->Z10_VALIDA == "1"
//
//			
//			U_CP01001R()
//		ENDIF 
//		
//		Z10->(DBSKIP())
//	ENDDO
//
//RESET ENVIRONMENT 
//
//Return



USER FUNCTION TST_PRFOR()

	Local nOpc := 3
	Local oModel := Nil
	Local cProd061 := "0002"
	Local cForn1 := "001"
	Local cLoja1 := "01"
	Local cForn2 := "002"
	Local cLoja2 := "01"
	
	nOpc := 3
	oModel := Nil
	
	oModel := FWLoadModel('MATA061')
	
	oModel:SetOperation(nOpc)
	oModel:Activate()
	
	//Cabeçalho
	oModel:SetValue('MdFieldSA5','A5_PRODUTO',SC7->C7_PRODUTO)
	
	//Grid
	oModel:SetValue('MdGridSA5','A5_FORNECE',SA2->A2_COD)
	oModel:SetValue('MdGridSA5','A5_LOJA' 	,SA2->A2_LOJA)																												
	
	If oModel:VldData()
		oModel:CommitData()
	Else
		aRet[1]	:= .F.
		aRet[2]	+= EOL+REPLICATE('-',80)+EOL+"Falha ao Gravar Produto X Fornecedor:"
	Endif
	
	oModel:DeActivate()
	
	oModel:Destroy()
	
	
RETURN()