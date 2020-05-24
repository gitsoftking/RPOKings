#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.ch"
#INCLUDE "TopConn.ch" 
#INCLUDE "TBICONN.CH"

#DEFINE EOL   chr(13)+chr(10) 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CP01EXP  บAutor  ณ Augusto Ribeiro	 บ Data ณ  21/03/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Exporta Dicionario de dados do Projeto                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
USER Function CP01EXP()
Local cDrive	:= "DBFCDX" //"CTREECDX"//"DBFCDX"     
Local cExt		:= IIF(cDrive == "CTREECDX", ".dtc", ".dbf")
Local aAlias	:= {}
Local aCampos	:= {}
Local aGatilhos	:= {}
Local aChvSX6	:= {} 
Local aConsPad	:= {}
Local cPrefixo	:= "" 
Local cDestino	:= "\data\compila\"
                       
	AADD(aAlias, "Z07")
	AADD(aAlias, "Z08")
	AADD(aAlias, "Z09")
	AADD(aAlias, "Z10")
	AADD(aAlias, "Z11")
	AADD(aAlias, "Z12")
	AADD(aAlias, "Z13")	

	aadd(aCampos, "C5_XCHVNFE")	
	aadd(aCampos, "F1_XCNFOBS")
	aadd(aCampos, "F1_XNFOBS")
	aadd(aCampos, "D1_XITEXML")	

	
	aadd(aGatilhos, {"Z07_TES", "001"})	
	
/*	                                               	
	aadd(aCampos, "A1_CODUNID")	
	

	aadd(aCampos, "Z64_MOTCAN")

	aadd(aCampos, "A5_CODPRF")
	aadd(aCampos, "E2_XSTATUS")
	aadd(aCampos, "F1_CHVNFE")	
	aadd(aCampos, "F1_XCNFOBS")	
	aadd(aCampos, "F1_XNFOBS")
	
	aadd(aChvSX6, "  MQ_XMLDEST")

	aadd(aConsPad, "ZA7")	
	
	CP03SX7
	
	
	//aadd(aGatilhos, {"CAMPO", "SEQUENCIA"})

	                              */   
	                              
	                              
	_cEmp		:= "99"
	_cFilial	:= "01"
	PREPARE ENVIRONMENT EMPRESA _cEmp FILIAL _cFilial

		cFullPath	:= cDestino+cPrefixo+"six"+cExt
		U_CP03SIX(cDrive, cFullPath, aAlias)
		
		cFullPath	:= cDestino+cPrefixo+"sx2"+cExt
		U_CP03SX2(cDrive, cFullPath, aAlias)

		cFullPath	:= cDestino+cPrefixo+"sx3"+cExt
		U_CP03SX3(cDrive, cFullPath, aAlias, aCampos)

//		cFullPath	:= cDestino+cPrefixo+"sx6"+cExt
//		U_CP03SX6(cDrive, cFullPath, aChvSX6)


		cFullPath	:= cDestino+cPrefixo+"sx7"+cExt
		U_CP03SX7(cDrive, cFullPath, aGatilhos)

//		cFullPath	:= cDestino+cPrefixo+"sxb"+cExt
//		U_CP03SXB(cDrive, cFullPath, aConsPad)
		
		
	RESET ENVIRONMENT
Return                
