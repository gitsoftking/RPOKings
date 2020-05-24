#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "MSOLE.CH"

#DEFINE EOL   chr(13)+chr(10) 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOMPILA   บAutor  ณAugusto Ribeiro	 บ Data ณ  10/04/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Biblioteca de funcoes genericas                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ COMPILA - www.compila.com.br                               บฑฑ
ฑฑฬออออออออออฯออออัออออออออัออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista Resp. ณ  Data  ณ       Manutencao Efetuada                    บฑฑ
ฑฑฬอออออออออออออออุออออออออุออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ               ณ  /  /  ณ                                              บฑฑ
ฑฑศอออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/ 



//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ FUNCTIONS | DESCRICAO                                                         ณ
//ณฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤณ
//ณ CopyX1    | Gera TXTcom codigo fonte da copia das perguntas                   ณ
//ณฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤณ
//ณ INQuery   | Recebe String separa por caracter "X" Retorna String pronta para  ณ
//ณ            IN em selects Ex.: Retorn: ('A','C','F')                           ณ
//ณฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤณ   
//ณ           |                                                                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ COPYX1                                        ณ
//ณ                                               ณ
//ณ PARAMETROS:	_cPergOri                         ณ
//ณ                                               ณ
//ณ RETORNO: Abre Bloco de Notas com Codigo Fonte ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
User Function CopyX1(_cPergOri)
Local _lRet			:= Nil                                
Local _cSource		:= ""       
Local _cPergOri
Local _nI			:= 0
Local _cField		:= ""  
Private	_EOL		:= chr(13)+chr(10)
Private _cFileLog,_cLogPath,_Handle


	IF !EMPTY(_cPergOri)
		_cPergOri	:= PADR(_cPergOri,6," ")
		DBSELECTAREA("SX1")
		SX1->(DBSETORDER(1))      
		SX1->(DBGOTOP())                 
		IF SX1->(DBSEEK(_cPergOri,.F.))	
			GrvLogTXT(1,"")
			WHILE SX1->(!EOF()) .AND. _cPergOri == SX1->X1_GRUPO

				_cSource	:= 'aAdd(aRegs,{cPerg
				For _nI:=2 to FCount()
					
					_cField	:= "SX1->"+FieldName(_nI)
					IF VALTYPE(&_cField) == "C"
						_cSource	+= ',"'+(&_cField)+'"'
					ELSEIF VALTYPE(&_cField) == "N"
						_cSource	+= ','+STR(&_cField)+''
					ELSE                                  
						_cSource	+= ',""'					
					ENDIF		
				Next                     
				GrvLogTXT(2,_cSource+"})"+_EOL)				

				SX1->(DBSKIP())
			ENDDO 
			GrvLogTXT(3,"")			
		ENDIF
	ENDIF

Return(_lRet)




//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Recebe String separa por caracter "X"            ณ
//ณ ou Numero de Caractres para "quebra" _nCaracX)   ณ
//ณ Retorna String pronta para IN em selects         ณ
//ณ Ex.: Retorn: ('A','C','F')                       ณ
//ณ                                                  ณ
//ณ PARAMETROS:  _cString, _cCaracX                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
User Function INQuery(_cString, _cCaracX, _nCaracX)
Local _cRet	:= ""                  
Local _cString, _cCaracX, _nCaracX, nY
Local _aString	:= {}                            
Default	_nCaracX := 0                   
                                                                  
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณValida Informacoes Basicas ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
    IF !EMPTY(_cString) .AND. (!EMPTY(_cCaracX) .OR. _nCaracX > 0)
                                
    	nString	:= LEN(_cString)
    	
		

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Utiliza Separacao por Numero de Caracteres ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		IF _nCaracX > 0
			FOR nY := 1 TO nString STEP _nCaracX
			
				AADD(_aString, SUBSTR(_cString,nY, _nCaracX) )
			
			Next nY
			
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Utiliza Separacao por caracter especifico ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		ELSE
			_aString	:= WFTokenChar(_cString, _cCaracX)		
		ENDIF
	                


		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Monta String para utilizar com IN em querysณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		_cRet	+=  "('"		
		FOR _nI := 1 TO Len(_aString)
			IF _nI > 1
				_cRet	+= ",'"
			ENDIF
			_cRet += ALLTRIM(_aString[_nI])+"'"	
		Next _nI
		_cRet += ") "  
		
	ENDIF

Return(_cRet)      


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณcpVldMail บAutor  ณAugusto Ribeiro     บ Data ณ  16/11/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida Sintaxe dos destinarios retornando somente          บฑฑ
ฑฑบ          ณdestinatarios com sintaxe correta                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParโmetrosณ _cDest:  E-mail dos destinatแrios seperados por ;          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Retorno  ณ _cRet: Destinatarios Validos 							  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Compila                                                    บฑฑ
ฑฑฬออออออออออฯออออัออออออออัออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista Resp. ณ  Data  ณ        Manutencao Efetuada                   บฑฑ
ฑฑฬอออออออออออออออุออออออออุออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAugusto Ribeiroณ27/11/07ณ Valida se o e-mail tem 2 "@"                 บฑฑ   
ฑฑบ               ณ  /  /  ณ                                              บฑฑ
ฑฑศอออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/ 
User Function cpVldMail(_cDest)
Local	_cRet		:= ""
Local	_cDest		
Local	_aDest		:= {}                     
Local 	_aVirgula	:= {}
Local	_cDestOK	:= ""
Local 	_aDestOK	:= {}
Local 	_aDestVgl	:= {}
Local	_cDestVgl	:= ""
Local 	_nI	  		:= 0
Local 	_nX	  		:= 0
Local	_lValid		:= .F.    
//| Caracteres Invalidos                                                                                    
Local 	_aInvalid	:= {"(",")","[","]","{","}","/","\","|","<",">","+","=","!","#","$","%","&","*",":","?","็","แ","เ","โ","ใ","้","่","๊","ํ","์","๎","๓","๒","๔","๕","๚","๙","๛","'",'"'}

	Conout("###| INICIO: cpVldMail "+" ("+DTOC(DATE())+" "+TIME()+")| Entrada: "+_cDest)	
                                                                                
	_cDest	:= STRTRAN(_cDest," ","")
	_cDest	:= Lower(_cDest)
	
	_aDest := WFTokenChar(_cDest,";")
	
	For _nI	:= 1 To Len(_aDest)                    
		
		IF  "," $ _aDest[_nI]
			_aVirgula := WFTokenChar(_aDest[_nI],",")
		ELSE
			_aVirgula := {}
		ENDIF
		                      
		/*----------------------------------|
		| Valida e-mails Separados por ";"	|
		|----------------------------------*/
		IF LEN(_aVirgula) <= 0
		
			FOR _nV := 1 To Len(_aInvalid)
				IF _aInvalid[_nV] $ _aDest[_nI]
					_lValid	:= .F.
					Exit
				Else
					_lValid	:= .T.
				EndIf
			Next _nV
			
			IF _lValid .AND.;
				AT("@.",_aDest[_nI])==0 .AND.;
				"@" $ _aDest[_nI].AND.;
				"." $ _aDest[_nI].AND.;
				!(SUBSTR(_aDest[_nI],LEN(_aDest[_nI]),1) == "@") .AND.;
				!("@" $ SUBSTR(_aDest[_nI],AT("@",_aDest[_nI])+1,LEN(_aDest[_nI]))) .AND.;		//|Verifica se tem 2 @
				!(SUBSTR(_aDest[_nI],LEN(_aDest[_nI]),1) == ".")
				                                                  
				
				
				AADD(_aDestOK,_aDest[_nI])
				
			EndIf                            
		/*----------------------------------|
		| Valida e-mails Separados por ","	|
		|----------------------------------*/			
		ELSE         
			_nX := 1
			_aDestVgl	:= {}  			
			_cDestVgl	:= ""     			
			FOR _nX := 1 To lEN(_aVirgula)
				_lValid		:= .F.		 
				_nV			:= 1
				
				FOR _nV := 1 To Len(_aInvalid)
					IF _aInvalid[_nV] $ _aVirgula[_nX]
						_lValid	:= .F.
						Exit
					Else
						_lValid	:= .T.
					EndIf
				Next _nV
						
				IF _lValid .AND.;
					AT("@.",_aVirgula[_nX])==0 .AND.;
					"@" $ _aVirgula[_nX].AND.;
					"." $ _aVirgula[_nX].AND.;
					!(SUBSTR(_aVirgula[_nX],LEN(_aVirgula[_nX]),1) == "@") .AND.;   
					!("@" $ SUBSTR(_aVirgula[_nX],AT("@",_aVirgula[_nX])+1,LEN(_aVirgula[_nX]))) .AND.;		//|Verifica se tem 2 @					
					!(SUBSTR(_aVirgula[_nX],LEN(_aVirgula[_nX]),1) == ".")
					
					AADD(_aDestVgl,_aVirgula[_nX])					
				EndIf                        
			NEXT _nX
			                       
			_nX := 1
			FOR _nX := 1 To lEN(_aDestVgl)
				IF EMPTY(_cDestVgl)
					_cDestVgl	:= _aDestVgl[_nX]
				ELSE
					_cDestVgl	+= ","+_aDestVgl[_nX]
				ENDIF
			NEXT _nX    
			
			IF !EMPTY(_cDestVgl)
				AADD(_aDestOK,_cDestVgl)
			ENDIF
		ENDIF		
	
	Next _nI
	

	_cRet	:= WFUnTokenChar(_aDestOK)
	        
	Conout("###| FIM: cpVldMail | RETORNO: "+_cRet)		
Return _cRet



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ cpToDate บAutor  ณ Augusto Ribeiro	 บ Data ณ  24/04/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Convert Caracter em Data                                   บฑฑ
ฑฑบ          ณ _cDate*    : Data a ser convertida                         บฑฑ
ฑฑบ          ณ _cLayDate* : LayOut da Data                                บฑฑ
ฑฑบ          ณ _cTpRet    : Tipo de Retorno (D/C/Y)                       บฑฑ
ฑฑบ          ณ              (D=Date, C=Caracter, S="YYYYMMDD")            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function cpToDate(_cDate,_cLayDate, _cTpRet)
Local _cLayDate, _cDate, _cTpRet
Local xRet		:= ""   
Local dDtAux	:= ""

Default	_cTpRet := "D"
	
IF !EMPTY(_cLayDate) .AND. !EMPTY(_cDate)

	_cLayDate	:= UPPER(_cLayDate)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Converte _cDate para data de acordo com o Layout de origem ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	IF _cLayDate == "YYYY-MM-DD"		 
		dDtAux	:= STOD(STRTRAN(ALLTRIM(_cDate),"-",""))		
	ENDIF      
	

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Converte data para o formato desejado ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	IF _cTpRet == "C"
		xRet	:= DTOC(dDtAux)
	ELSEIF _cTpRet == "S"
		xRet	:= DTOS(dDtAux)	
	ELSEIF _cTpRet == "D"
		xRet	:= dDtAux
	ENDIF

ENDIF               

Return(xRet)



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ cpGrvLog บAutor  ณ Augusto Ribeiro	 บ Data ณ  24/04/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Realiza a Cria็ใo, Gravacao, Apresentacao do Log           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบPARAMETROSณ _nOpc : 1=Cria Arquivo, 2= Grava Log, 3 = Apresenta Log    บฑฑ
ฑฑบ          ณ _cTxtLog : Log a ser gravado                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ*ATENCAO* ณ Necessario a criacao das variaveis como Private            บฑฑ
ฑฑบ          ณ Private _cFileLog	 	:= ""                             บฑฑ
ฑฑบ          ณ Private _cLogPath		:= ""                             บฑฑ
ฑฑบ          ณ Private _Handle			:= ""                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
USER Function cpLogTxt(_nOpc, _cTxtLog)
Local _lRet	:= Nil
Local _nOpc, _cTxtLog  
Local cLogIni	:= ""
                                                                  
Default _nOpc		:= 0
Default _cTxtLog 	:= ""                                            

	Do Case
		Case _nOpc == 1
			//_cFileLog	 	:= Criatrab(,.F.)                        
			_cFileLog		:= ALLTRIM(SUBSTR(cUsuario,7,15))+"_"+DTOS(DDATABASE)+"_"+STRTRAN(TIME(),":","-")
			_cLogPath		:= AllTrim(GetTempPath())+_cFileLog+".txt"
			_Handle			:= FCREATE(_cLogPath,0)	//| Arquivo de Log		
			
			
			cLogIni	:= "**** INICIO ****"+EOL
			cLogIni	+= 'DATABASE...........: ' + DtoC(dDataBase)+EOL
			cLogIni	+= 'DATA - HORA........: ' + DtoC(Date())+" - "+Time()+EOL				
			cLogIni	+= 'ENVIRONMENT........: ' + GetEnvServer()+EOL
			cLogIni	+= 'EMPRESA / FILIAL...: ' + SM0->M0_CODIGO + '/' + SM0->M0_CODFIL+EOL
			cLogIni	+= 'USUมRIO............: ' + cUserName+EOL
			cLogIni	+= REPLICATE("-",80)+EOL
			
			FWRITE (_Handle, cLogIni+EOL+_cTxtLog)
			
		Case _nOpc == 2                   
			IF !EMPTY(_cTxtLog)
				FWRITE (_Handle, _cTxtLog)
			ENDIF		
			
		Case _nOpc == 3
			
			cLogIni	:= REPLICATE("-",80)+EOL
			cLogIni	+= 'DATA - HORA........: ' + DtoC(Date())+" - "+Time()+EOL				
			cLogIni	+= "**** FIM ****"+EOL				
					
			FWRITE (_Handle, cLogIni+EOL+_cTxtLog)

			FCLOSE(_Handle)	          
			WINEXEC("NOTEPAD "+_cLogPath)	 
	EndCase

Return(_lRet)





/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ cpToDate บAutor  ณ Augusto Ribeiro	 บ Data ณ  02/05/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Converte caracter em Array, contemplando ranges, ex.: 10-20บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบParametrosณ cString    : Data a ser convertida                         บฑฑ
ฑฑบ          ณ cQuebra    : LayOut da Data                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบRetorno   ณ aArray                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function cpC2A(cString, cQuebra)
Local aRet	:= {}
Local aAux	:= {}
Local nAux, nI, nPosRange
Local cCharIni, cCharAtual, cCharFim
            
Default cQuebra := "/"            


aAux	:= WFTokenChar(cString, cQuebra)	
nAux	:= LEN(aAux)  

IF nAux > 0
	FOR nI := 1 TO nAux
		  
		nPosRange	:= AT("-",aAux[nI])
		IF nPosRange > 0
			cCharIni	:= ALLTRIM(LEFT(aAux[nI], nPosRange-1))
			cCharFim 	:= ALLTRIM(SUBSTR(aAux[nI], nPosRange+1, (LEN(aAux[nI])-nPosRange) ))
			cCharAtual	:= cCharIni
			
			WHILE cCharFim >= cCharAtual

				AADD(aRet, ALLTRIM(cCharAtual))
				
				cCharAtual	:= SOMA1(cCharAtual)
			ENDDO
		ELSE
			AADD(aRet, ALLTRIM(aAux[nI]))
		ENDIF				
	NEXT nI
ENDIF
            
Return(aRet)



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ ReadErrorบAutor  ณAugusto Ribeiro     บ Data ณ 21/12/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Le recebe string de erro da ExecAuto e retorna o que ้     บฑฑ
ฑฑบ          ณ relevante                                                  บฑฑ
ฑฑบ          ณ			                                                  บฑฑ
ฑฑบParametrosณ cErro: Mensagem de Erro a ser tratada                      บฑฑ
ฑฑบ          ณ lRetTabela: Retorna Nome da tabela que gerou a Falha.      บฑฑ
ฑฑบ          ณ			                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/ 
User Function cpReadError(cErro, lRetTabela)  
Local cQuery                
Local cErro

Local cErroPart		:= ""
Local cErroAmigo	:= ""
Local cErroAux		:= ""
Local cAliasErro	:= ""

Local nPos1, nPos2	                  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Indica a posicao para iniciar a leitura.              ณ
//ณ Posicao se altera de acordo com os caracteres ja lido ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local nPosRead	:= 1 

Default lRetTabela	:= .F.
     


IF !EMPTY(cErro)
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ                                     ณ
	//ณ Recupera somente a mensagem do HELP ณ
	//ณ                                     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cErro	:= alltrim(cErro)         
	IF LEFT(cErro,5) == "HELP:"      
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Busca primeira quebra de linha.   ณ
		//ณ Indica inicio da mensagem de help ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		nPos1	:= At(EOL,cErro)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Busca duas quebra se linhas na sequencia ณ
		//ณ Indica o fim da mensagem do Help         ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		nPos2 		:= At(EOL+EOL,cErro)
		IF nPos2 <= 0
			nPos2	:= LEN(cErro)
		ENDIF
	
		nPosRead	:= nPos2+3	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Se posicoes forem diferentes, indica que existe mensagem de Help ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		IF nPos1 <> nPos2  
			nPos2	:= ((nPos2-1)-nPos1)
			cErroAmigo += "MSG.ERRO:"+REPLACE(SUBSTR(cErro, nPos1+2, nPos2-1), "xx","")
		ENDIF
		
	ENDIF      
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ                                                            ณ
	//ณ Busca nome da Tabela que gerou o Erro Ex. (Cabec ou Itens) ณ
	//ณ                                                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	IF lRetTabela                                                                
		cErroPart	:= alltrim(SUBSTR(cErro, nPosRead, len(cErro)))
		    
		nPos2		:= At("TABELA ",UPPER(cErroPart))   
		IF nPos2 > 0
			cAliasErro	:= SUBSTR(cErroPart, nPos2+LEN("TABELA "), 3)   
			
			
			DbSelectArea("SX2")      
			SX2->(DBSETORDER(1))
			IF SX2->(Dbseek(cAliasErro, .F.))
				cErroAux	:= "TABELA:"+cAliasErro+"-"+ALLTRIM(SX2->X2_NOME)
				
				cErroAmigo 	:= cErroAux+" |"+cErroAmigo
			ENDIF 
		ENDIF	
	ENDIF
	
	
	             
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ                                        ณ
	//ณ Recupera linha do campo  <-- Invalido  ณ
	//ณ                                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cErroPart	:= alltrim(SUBSTR(cErro, nPosRead, len(cErro)))
	    
	nPos2		:= At("< --",cErroPart)
	IF nPos2 > 0
		nPos2		:= (At(EOL,alltrim(Substr(cErroPart,nPos2,len(cErroPart)) ))+nPos2)-1
		nPos1		:= Rat(EOL,Substr(cErroPart,1,nPos2))+2
		
		IF !EMPTY(cErroAmigo)
			cErroAmigo	+= "|"
		ENDIF
		cErroAmigo	+=  "CAMPO:"+Substr(cErroPart,nPos1,nPos2-nPos1)	                                                
	ENDIF
		
	cErroAmigo	:= ALLTRIM(cErroAmigo)  
ENDIF

Return(cErroAmigo)





/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ cpFunJob บAutor  ณAugusto Ribeiro     บ Data ณ 29/06/2011  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Executa bloco de codigo como job                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบParametrosณ cCodEmp, cCodFil, aBloco                                   บฑฑ
ฑฑบ          ณ			                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/ 
User Function cpFunJob(cCodEmp, cCodFil, aBloco)
       
CONOUT("###|  "+cCodEmp+" "+cCodFil)      

CONOUT("###| BLOCO: "+VALTYPE(aBloco))

RpcSetType(3)
RpcSetEnv( cCodEmp, cCodFil,,,/* 'COM' */)

//	PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01"	

//	aEval(aBloco, {|x| eval(x) })                  
	For nI := 1 to len(aBloco)        
	
		CONOUT("###| BLOCO: "+aBloco[nI])
	
		&(aBloco[nI])	
	Next nI
	
//	RESET ENVIRONMENT		
	
RpcClearEnv()

Return()


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ cpINQry  บAutor  ณAugusto Ribeiro     บ Data ณ 29/06/2011  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Recebe Arry ou String separa por caracter "X" ou Numero de บฑฑ
ฑฑบ          ณ Caractre para "quebra" _nCaracX) Retorna String pronta paraบฑฑ
ฑฑบ          ณ  IN em selects Ex.: Retorn: ('A','C','F')                  บฑฑ
ฑฑบ          ณ			                                                  บฑฑ
ฑฑบParametrosณ _cString, _cCaracX                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/ 
User Function cpINQry(_cString, _cCaracX, _nCaracX)
Local _cRet	:= ""                  
Local _cString, _cCaracX, _nCaracX, nY
Local _aString	:= {}                            
Default	_nCaracX := 0                   
                                                                  
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณValida Informacoes Basicas ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
   	IF VALTYPE(_cString) == "C" .AND. !EMPTY(_cString) .AND. (!EMPTY(_cCaracX) .OR. _nCaracX > 0)

    	nString	:= LEN(_cString)
    	
		

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Utiliza Separacao por Numero de Caracteres ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		IF _nCaracX > 0
			FOR nY := 1 TO nString STEP _nCaracX
			
				AADD(_aString, SUBSTR(_cString,nY, _nCaracX) )
			
			Next nY
			
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Utiliza Separacao por caracter especifico ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		ELSE
			_aString	:= WFTokenChar(_cString, _cCaracX)		
		ENDIF   
		
	ELSEIF VALTYPE(_cString) == "A"
		_aString	:= _cString
	ENDIF
	                
	
	IF LEN(_aString) > 0

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Monta String para utilizar com IN em querysณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		_cRet	+=  "("		
		FOR _nI := 1 TO Len(_aString)
			IF _nI > 1
				_cRet	+= ","
			ENDIF        
			
			IF VALTYPE(_aString[_nI]) == "C"
				_cRet	+= "'"+ALLTRIM(_aString[_nI])+"'"
			ELSEIF VALTYPE(_aString[_nI]) == "N"
				_cRet	+= ALLTRIM(STR(_aString[_nI]))
			ENDIF
			
		Next _nI
		_cRet += ") "  
	ENDIF

Return(_cRet)      



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ cpHeadOrd บAutor  ณ Augusto Ribeiro	 บ Data ณ  12/03/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Fncao para ordenacao do list pelo click no cabecalho      บฑฑ
ฑฑบ          ณ Necessario declarar _nColAnt como PRIVATE                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function cpHeadOrd(oLbxAux, nCol, lMark)
Local lMark
Local LMARKALL

Default lMark	:= .F.


If	nCol > 0

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Marca/Desmarca Registrios ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If nCol == 1 .AND. lMark
	                   
		lMarkAll	:= !(lMarkAll)

		aEval(oLbxAux:aArray, {|x| x[1] := lMarkAll} )
		_nColAnt := nCol			
	
	ELSEIF nCol == _nColAnt
		aSort(oLbxAux:aArray,,,{ |x,y| x[nCol] < y[nCol] })
		_nColAnt := 0
	Else
		aSort(oLbxAux:aArray,,,{ |x,y| x[nCol] > y[nCol] })
		_nColAnt := nCol
	EndIf

	oLbxAux:Refresh()
	
	
EndIf

Return()



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณcpGrvCad  บAutor  ณ Augusto Ribeiro	 บ Data ณ  28/02/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria janela para tratamento manual dos erros na importacao บฑฑ
ฑฑบ          ณ  de cadastros                                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบParametrosณ cAliasImp, cTituloImp, cFuncao, aDadosImp                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User function cpGrvCad(cAliasImp, cTituloImp, cFuncao, aDadosImp)
Local aAlterEnch := {} //{'F1_XTIPONF', 'F1_XNFREF'}  //Vetor com nome dos campos que poderao ser editados
					 
Local aCpoEnch   := {} // {'F1_DOC','F1_SERIE'}// Vetor com nome dos campos que serao exibidos. Os campos de usuario sempre serao exibidos se nao existir no parametro um elemento com a expressao "NOUSER"
					
Local aPos       := {C(018),C(004),C(610),C(720)}  //Vetor com coordenadas para criacao da enchoice no formato <top>, <left>, <bottom>, <right>
Local cAliasE    := cAliasImp  //Tabela cadastrada no Dicionario de Tabelas (SX2) que sera editada
Local caTela     := cTituloImp+" - Tratamento Manual"  // Nome da variavel tipo "private" que a enchoice utilizara no lugar da propriedade aTela
Local lColumn    := .F.  //Indica se a apresentacao dos campos sera em forma de coluna
Local lF3        := .F.  //Indica se a enchoice esta sendo criada em uma consulta F3 para utilizar variaveis de memoria
Local lMemoria   := .T.  //Indica se a enchoice utilizara variaveis de memoria ou os campos da tabela na edicao
Local lNoFolder  := .F.  //Indica se a enchoice nao ira utilizar as Pastas de Cadastro (SXA)
Local lProperty  := .T.  //Indica se a enchoice nao utilizara as variaveis aTela e aGets, somente suas propriedades com os mesmos nomes
Local nModelo    := 3  //Se for diferente de 1 desabilita execucao de gatilhos estrangeiros
Local nOpcE      := 3  //Numero da linha do aRotina que definira o tipo de edicao (Inclusao, Alteracao, Exclucao, Visualizacao)
Local nRegE      := 0  //Numero do Registro a ser Editado/Visualizado (Em caso de Alteracao/Visualizacao)
Local nY 
Local aButtons	:= {}     
Local lAbort	:= .F.

Private bCampo   := {|nCPO| Field(nCPO)}
Private ALTERA   := .F.
Private DELETA   := .F.
Private INCLUI   := .T.
Private VISUAL   := .F.   
Private lGravou		:= .F.


SetPrvt("oDlg1")
                   
	DBSELECTAREA("SX3")
	aAreaSX3	:= GETAREA() 
	                          
	SX3->(DBSETORDER(1))
	SX3->(DBSEEK(cAliasImp))    
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Campos para Janela ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	WHILE SX3->X3_ARQUIVO == cAliasImp .AND. SX3->(!EOF())

		IF X3USO(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL
			AADD(aCpoEnch, SX3->X3_CAMPO)			
			IF SX3->X3_CONTEXT <> 'V'              
				AADD(aAlterEnch, SX3->X3_CAMPO)						
			ENDIF			
		ENDIF                                    
	     
		SX3->(DBSKIP())
	ENDDO	
	RestArea(aAreaSX3)

//	Aadd( aButtons, {"FINAL_MDI",{ || lGravou := .T., lAbort := .T., oDlg1:END()},"Abortar Operacao", "SAIR"} )

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Ajusta a largura para o tamanho padrao Protheus ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aSize := MsAdvSize() 
	aSize[5] := 632      
	aSize[3] := 318	
	aObjects := {}
	AAdd( aObjects, { 100, 100, .T., .T. } )
	aInfo    := { aSize[1],aSize[2],aSize[3],aSize[4],2,2 } 	
	aPosObj := MsObjSize( aInfo, aObjects ) 	
	
	WHILE !lGravou .AND. !lAbort

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Preenche campos para agilizar incliusao manual do usuario ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
		RegToMemory(cAliasImp, .T.)			
		
		IF cAliasImp == "SB1"
			M->B1_FILIAL := XFILIAL("SB1")
		ENDIF 	 
		
		For nY := 1 To len(aDadosImp)
			IF !EMPTY(alltrim(aDadosImp[nY,2]))
				//M->&(ALLTRIM(aDadosImp[nY,1]))	:= alltrim(aDadosImp[nY,2])
				M->&(ALLTRIM(aDadosImp[nY,1]))	:= aDadosImp[nY,2]
			ENDIF
		Next nY			
	
		oDlg1      := MSDialog():New( aSize[7],0,aSize[6],aSize[5],caTela,,,.F.,,,,,,.T.,,,.T. )
	
//		Aadd( aButtons, {"DESTINOS",{ || GeraPedido()		},"Ir para Proximo registro", "Skip"} )	
		
		oDlg1:bInit := {||EnchoiceBar(oDlg1, {|| GrvAgain(cAliasImp, cTituloImp, cFuncao, @aDadosImp), IIF(lGravou, oDlg1:END(),NIL)},{|| lGravou	:= .T., oDlg1:END()},.F.,aButtons)}
	
		Enchoice(cAliasE,nRegE,nOpcE,"AC",/*cLetra*/,/*cTexto*/,aCpoEnch,aPosObj[1],aAlterEnch,nModelo,2,/*cMensagem*/,/*cTudoOk*/,oDlg1,lF3,lMemoria,lColumn,/*caTela*/,lNoFolder,lProperty)

		oDlg1:Activate(,,,.T.)		

	ENDDO

Return(lAbort)

         

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GrvAgain บAutor  ณ Augusto Ribeiro	 บ Data ณ  28/02/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Quando a Gravacao do registro falha, apresenta novamente   บฑฑ
ฑฑบ          ณ a janela para que os dados sejam completados/corrigidos    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบParametrosณ cAliasImp, cTituloImp, cFuncao, @aDadosImp                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GrvAgain(cAliasImp, cTituloImp, cFuncao, aDadosImp) 
Local aCpoAux	:= {}
Local lUsdSx3	:= .T.
Local aAreaSx3

DBSELECTAREA(cAliasImp)	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta Array com dados do cliente ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aDadosImp	:= {}
		
	For nI := 1 To (cAliasImp)->(FCOUNT())
		IF !EMPTY(M->&(FieldName(nI))) 			
			aArea := GetArea() 
			lUsdSx3 :=  GetX3Info( ALLTRIM( FieldName(nI)) )	
			RestArea(aArea)

//			DBSELECTAREA("SX3")
//			aAreaSX3	:= SX3->(GetArea())
//			SX3->(DBSETORDER(2)) //| X3_CAMPO
					
			IF lUsdSx3								
				AADD(aDadosImp,{FieldName(nI)		,M->&(FieldName(nI))	,Nil})			
			ENDIF 		
		ENDIF
	Next nI		
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Grava Cliente Via ExecAuto ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Begin Transaction
		lMSErroAuto := .F.   
		__cINTERNET		:= "AUTOMATICO"   
		MSExecAuto({|x,y| &(cFuncao)(x,y)},aDadosImp,3)  
		__cInterNet := Nil		
	End Transaction
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Grava Log de Importacaoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lMSErroAuto  
		DisarmTransaction()   
		MOSTRAERRO()
		lGravou	:= .F.
	ELSE
		MSGBOX("Registro gravado com Sucesso!",cTituloImp,"INFO")
		lGravou	:= .T.
	ENDIF
Return
 


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma   ณ   C()   ณ Autores ณ Norbert/Ernani/Mansano ณ Data ณ10/05/2005ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao  ณ Funcao responsavel por manter o Layout independente da       ณฑฑ
ฑฑณ           ณ resolucao horizontal do Monitor do Usuario.                  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function C(nTam)                                                         
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor     
	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)  
		nTam *= 0.8                                                                
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600                
		nTam *= 1                                                                  
	Else	// Resolucao 1024x768 e acima                                           
		nTam *= 1.28                                                               
	EndIf                                                                         
                                                                                
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ                                               
	//ณTratamento para tema "Flat"ณ                                               
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                                               
	If "MP8" $ oApp:cVersion                                                      
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()                      
			nTam *= 0.90                                                            
		EndIf                                                                      
	EndIf                                                                         
Return Int(nTam)      

/*/{Protheus.doc} GetX3Info
Verifica se Campo ้ usado
@author Jonatas Oliveira | www.compila.com.br
@since 01/07/2019
@version 1.0
/*/
Static Function GetX3Info(cCampo)
	Local lRet	:= .F. 
	
	aArea		:= GetArea()
	aAreaSX3	:= SX3->(GetArea())
	
	DBSELECTAREA("SX3")
	
	SX3->(DBSETORDER(2)) //| X3_CAMPO
	
	IF !EMPTY(cCampo)		
		IF SX3->(DBSEEK(cCampo))
			IF X3USO(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL
				lRet	:= .T.
//				ConOut(cCampo + " USADO " )
//			ELSE
//				ConOut(cCampo + " NรO USADO " )
			ENDIF 
		ENDIF
	ENDIF
	
	RESTAREA(aAreaSX3)
	RESTAREA(aArea)
	
Return(lRet)      
