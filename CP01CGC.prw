#include 'protheus.ch'
#include 'parmtype.ch'

user function CP01CGC()
	Local cRet := ""
	
	//Conout("###| CP01CGC: "+Z10->Z10_CNPJ);
	 
	//PicCli("F")
	IF LEN(ALLTRIM(Z10->Z10_CNPJ)) == 14 
		cRet := PicCli("J")
	ELSE
		cRet := PicCli("F")//"@R 999.999.999-99 " 	
	ENDIF 
	
return(cRet)