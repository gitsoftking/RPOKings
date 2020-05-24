#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TBICONN.CH"

#DEFINE EOL			Chr(13)+Chr(10)


Static _lImpEnt  	:= U_CP01005G("10", "XMLENTRADA")
Static _lImpSai 	:= U_CP01005G("10", "XMLSAIDA")
Static _lVldNfe  	:= U_CP01005G("10", "XMLVLD")

Static _lGeraPreNF  := U_CP01005G("11", "XMLGPNF")
Static _lDocEnt		:= U_CP01005G("11", "GERADOCAUT")
Static _lGeraPV		:= U_CP01005G("12", "XMLGPNF")
Static _lDocSai		:= U_CP01005G("12", "GERADOCAUT")
Static _cDtlib		:= "20990331"
//Static _lCteTom3	:= U_CP01005G("11", "CTETOMA3")

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CP01001  บAutor  ณ Augusto Ribeiro	 บ Data ณ  04/12/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Interface com usuแrio para importa็ใo do XML da Danfe.     บฑฑ
ฑฑบ          ณ Modo Administrador, Visualiza todas as empresas            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function CP01001(cFiltro)
	
	
	Private cCadastro 	:= OemToAnsi("Importa DANFE.XML")
	Private aRotina
	Private aRotTeste	:= {}
	Private aRotSefaz	:= {}
	Private aRotLote	:= {}
	Private aRotAdic	:= {}
	
	
	Private aAuto   	:= {}
	
	IF dDataBase < STOD(_cDtlib) .AND. DATE() < STOD(_cDtlib)
		
		aRotSefaz	:= 	  { { "Valid.Automac"	,"U_CP01001V(1)"			,0,3}	,;
			{ "Cons.Completa"	,"U_CP01001V(2)"			,0,3}	}
		
		IF _lImpSai
			aRotLote	:= 	  { { "Lote PV/Pre-Nota"	,"Processa({|| U_CP0101CT(.F.)})"			,0,3} ,;
								{ "Gera NF Lote"		,"Processa({|| U_CP01001T(.F.)})"			,0,3} }
			
			aRotina		:=	  { { 'Pesquisar' 			,'AxPesqui' 								,0,1} ,;
								{ "Visualizar"			,"U_CP01001F"  								,0,2} ,;
								{ "Manut.XML"			,"U_CP01001F('Z10',Z10->(RECNO()),4)"  		,0,4} ,;
								{ "SEFAZ"				,aRotSefaz									,0,3} ,;
								{ "Importar XML"		,"U_CP01001B"								,0,3} ,;
								{ "Gera PV/Pre-Nota"	,"Processa({|| U_CP01001C(.F.)})"			,0,3} ,;
								{ "Gera Nota Fiscal"	,"Processa({|| U_CP01001N(.F.)})"			,0,3} ,;
								{ "PROC. LOTE"			,aRotLote									,0,3} ,;
								{ "Reprocessar XML" 	,"Processa({|| U_CP01001R() },'Processando...')"	,0,3} ,;
								{ "Recuperar XML"		,"U_CP01001E"								,0,3} ,;																						
								{ "Legenda"				,"U_CP01001L"					   			,0,3}}								
								
								/*{ "Imprime Danfe"			,"U_XMLDanfe"									,0,3} ,;
								{ "Recuperar XML em Lote" ,"U_CP0100EL"								,0,3} ,;
								{ "Vencimento CTE em Lote","U_CP01CTEL"								,0,3} ,;	
								*/
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ P.E. utilizado para adicionar items no Menu da mBrowse       ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If ExistBlock("CP0101BR")
				aRotAdic := ExecBlock("CP0101BR",.f.,.f.)
				If ValType(aRotAdic) == "A"
					AEval(aRotAdic,{|x| AAdd(aRotina,x)})
				EndIf
			EndIf
			
			
		ELSE
			aRotLote	:= 	  {		{ "Lote Pre-Nota"		,"Processa({|| U_CP0101CT(.F.)})"			,0,3}}
			
			aRotina		:=	  { { 'Pesquisar' 				,'AxPesqui' 									,0,1} ,;
								{ "Visualizar"				,"U_CP01001F"  									,0,2} ,;
								{ "Manut.XML"				,"U_CP01001F('Z10',Z10->(RECNO()),4)"  			,0,4} ,;
								{ "SEFAZ"					,aRotSefaz										,0,3} ,;
								{ "Importar XML"			,"U_CP01001B"									,0,3} ,;
								{ "Gera Pre-Nota"			,"Processa({|| U_CP01001C(.F.)})"				,0,4} ,;
								{ "Gera Nota Fiscal"		,"Processa({|| U_CP01001N(.F.)})"				,0,3} ,;
								{ "PROC. LOTE"				,aRotLote										,0,3} ,;
								{ "Reprocessar XML" 		,"Processa({|| U_CP01001R() },'Processando...')",0,3} ,;
								{ "Recuperar XML"			,"U_CP01001E"									,0,3} ,;								
								{ "Legenda"					,"U_CP01001L"						   			,0,3} ,;
								{ "Integra SE" 			    ,"Processa({|| U_WSSE011() },'Integrando...')"	,0,3}}
			
								/*
								{ "Recuperar XML em Lote" 	,"U_CP0100EL"									,0,3} ,;
								{ "Imprime Danfe"			,"U_XMLDanfe"									,0,3} ,;
								{ "Vencimento CTE em Lote"	,"U_CP01CTEL"									,0,3} ,;
								*/
			/*
			aRotina		:=	  { { 'Pesquisar' 			,'AxPesqui' 									,0,1} ,;
								{ "Visualizar"			,"U_CP01001F"  									,0,2} ,;
								{ "Manut.XML"			,"U_CP01001F('Z10',Z10->(RECNO()),4)"  			,0,4} ,;
								{ "SEFAZ"				,aRotSefaz										,0,3} ,;
								{ "Importar XML"		,"U_CP01001B"									,0,3} ,;
								{ "Gera Pre-Nota"		,"Processa({|| U_CP01001C(.F.)})"				,0,3} ,;
								{ "Gera Nota Fiscal"	,"Processa({|| U_CP01001N(.F.)})"				,0,3} ,;
								{ "PROC. LOTE"			,aRotLote										,0,3} ,;
								{ "Reprocessar XML" 	,"Processa({|| U_CP01001R() },'Processando...')",0,3} ,;
								{ "Recuperar XML"		,"U_CP01001E"									,0,3} ,;
								{ "Imprime Danfe"		,"U_XMLDanfe"									,0,3} ,;
								{ "Legenda"				,"U_CP01001L"						   			,0,3} }
			*/
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ P.E. utilizado para adicionar items no Menu da mBrowse       ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If ExistBlock("CP0101BR")
				aRotAdic := ExecBlock("CP0101BR",.f.,.f.)
				If ValType(aRotAdic) == "A"
					AEval(aRotAdic,{|x| AAdd(aRotina,x)})
				EndIf
			EndIf
		ENDIF
		
		
		
		
		DBSELECTAREA("Z10")
		Z10->(DBSETORDER(1))
		//MBrowse(nT,nL,nB,nR,cAlias,aFixe,cCpo,nPosI,cFun,nDefault, aColors,cTopFun,cBotFun, nFreeze,bParBloco, lNoTopFilter, lSeeAll,lChgAll, cExprFilTop )
		mBrowse( 6, 1,22,75,"Z10",,,,"U_CP01001F",,U_CP01001L(),,, ,, ,,, cFiltro)
		
	ELSE
		Help( ,, 'HELP',, 'Rotina indisponํvel, fora do perํodo de teste. Por gentileza entrar em contato com a Compila Tel.: (11) 4306-3036 Site.: www.compila.com.br ', 1, 0)
	ENDIF
	
Return




/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CP01001U บAutor  ณ Augusto Ribeiro	 บ Data ณ  04/12/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Interface com usuแrio - Filtra Empresa Filial e omite opcs บฑฑ
ฑฑบ          ณ do Menu                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function CP01001U()  
Local cFiltro	:= "Z10_CODEMP = '"+ALLTRIM(SM0->M0_CODIGO)+"' AND Z10_CODFIL = '"+ALLTRIM(SM0->M0_CODFIL)+"'"
                         
	U_CP01001(cFiltro)

Return


/*            
cTipo:  DE = DANE ENTRADA
		DS = DANE SAIDA
		DC = DANE XML CANCELAMENTO

aRet { {<cTipo>, <lImport>, <cMsgErro>, <cChave>} }
*/

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CP01001A บAutor  ณ Augusto Ribeiro	 บ Data ณ  03/12/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Le XML e importa para tabela de arquivos recebidos         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบPARAMETROSณ cPathXML = Caminho do XML                                  บฑฑ
ฑฑบ          ณ lGeraPreNF = Gerar pre-nota ao importar o XML              บฑฑ
ฑฑบ          ณ lMoveRej = Move  arquivos regitados (Default .F. = Remov)  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบRETORNO   ณ aRet { {<cTipo>, <lImport>, <cMsgErro>, <cChave>, <nZ10Recno>} } บฑฑ
ฑฑบ          ณ cTipo:  DE = DANFE ENTRADA								  บฑฑ
ฑฑบ          ณ 		DS = DANFE SAIDA                                      บฑฑ
ฑฑบ          ณ 		DC = DANFE XML CANCELAMENTO                           บฑฑ
ฑฑบ          ณ      ER = Erro, Falha importacao do arquivo                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function CP01001A(cPathXML, lGeraPreNF, lMoveRej)
Local aRetModelo	:= {"ER", .F., "", "", 0}
//Local aRet			:= {.F., "", .F., ""}
Local aRet			:= {}
Local oXML, cXML, nI
Local nItem, nDup, aDuplic, lGrvDup , nFat, aFatRef,lGrvFat
Local cAviso  		:= ""
Local cErro	  		:= "" 
                                                                                                        
Local cPathTemp		:= LOWER(ALLTRIM(U_CP01005G("10", "XMLTEMP"))) //| Path dos arquivos XML Temporarios
Local cPathRej		:= LOWER(ALLTRIM(U_CP01005G("10", "XMLREJ"))) //| Path dos arquivos Rejeitados
Local cPathEnt		:= LOWER(ALLTRIM(U_CP01005G("11", "XMLOK"))) //| Path de destino dos arquivos - ENTRADA
Local cPathSai		:= LOWER(ALLTRIM(U_CP01005G("12", "XMLOK"))) //| Path de destino dos arquivos - SAIDA
Local cPathDest  

Local cNomeArq 		:= ""
Local cFullPath		:= ""                        
Local cInfAdic 		:= "" 
Local cChvRef		:= ""
Local cJustif  		:= ""      
Local cTipoNF		:= ""
Local cDestCNPJ		:= ""
Local aEmpFil, aRetPreNota, cTipoOper
Local lImpXML  		:= .T.          
Local lRemovArq		:= .F.      
Local aRetISXML		:= {.T., ""}
Local aISXMLCanc	:= {.T.,""}
Local aEntSai		:= {}
Local lDelArqCan	:= .F.	
Local nVlrIcmT,dDtEmiss,nValFret
Local cTpFrete := ""

Local oXML, oDANFE, oEmitente, oIdent, oDet, oTotal, oCobr,oCanDanfe, aDadosCan
Local cNumNfe, cCnpj, cRazao, aEmpSai, aEmpEnt, lDelArqTemp, cStatus, cTomaTip
Local cMunOri 	:= ""
Local cMunDes 	:= ""
Local cUfOrig 	:= ""
Local cUfDest 	:= ""
Local cCodProCte	:= ""    
Local cCNPJCPF	:= ""
//Local oError := ErrorBlock({|e| Conout("###| CP01001A - Erro ao abrir XML: "+e:Description), aRet[2] := "Erro ao abrir XML: "+e:Description})
Local lEmpFil 		:= .F.  
//Private lTpNfeProc	:= .F.
Private lTpNfe		:= .F.
Private lTpCte		:= .F.
Private cCfSrvB		:= ALLTRIM(LOWER(ALLTRIM(U_CP01005G("11", "CFSRVBEN")))) //|CFOP de servi็o de beneficiamento
Private cPrSrvB		:= UPPER(ALLTRIM(U_CP01005G("11", "PRSRVBEN"))) //|Codigo Produto de servi็o de beneficiamento

Default cPathXML	:= ""    
Default lGeraPreNF	:= .F. // U_CP01005G("11", "XMLGPNF")	//| Gera Pre-Nota apos importadar Danfe
Default lMoveRej	:= .T.


AADD(aRet, ACLONE(aRetModelo))

Conout("###| CP01001A: "+cPathXML) 
           
//Begin Sequence
           
cPathXML	:= Lower(cPathXML)			//| Todo o caminho deve ser minusco, evita problemas com Linux
cNomeArq	:= alltrim(Lower(NomeArq(cPathXML)))		//| Retorna Nome do Arquivo


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Tratamento para arquivos com nome maior que 200 caracteres ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
IF LEN(cNomeArq) > 200
	cNomeArq	:=	U_CP01G02(cNomeArq)
ENDIF

                             
IF !EMPTY(cPathXML) .AND. !EMPTY(cNomeArq)  


	lImpXML	:= .T.

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica se o Arquivo jแ foi importado ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Z10->(DBSETORDER(4))	//| Z10_FILIAL, Z10_ARQUIV
	IF Z10->(DBSEEK(XFILIAL("Z10")+cNomeArq,.F.)) 
		lImpXML	:= .F.
	ELSE     
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Verifica se o Arquivo jแ foi importado como XML de Cancelamento ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		Z10->(DBSETORDER(5))	//| Z10_FILIAL, Z10_ARQCAN	
		IF Z10->(DBSEEK(XFILIAL("Z10")+cNomeArq,.F.))
			lImpXML	:= .F.
		ENDIF
	ENDIF
	
	
	IF lImpXML
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Copia Arquivos para a Pasta Temp e Verifica se a Nota ja foi importada ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	                               
		cFullPath	:= ALLTRIM(cPathTemp+cNomeArq)
		IF cPathXML <> cFullPath
			__CopyFile(cPathXML, cFullPath)
		ENDIF
		
		IF FILE(cFullPath)	//| Verifica se o arquivo foi copiado com sucesso.
	
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณTransforma XML e OBJETO ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			oXML := XmlParserFile(cFullPath,"_",@cErro, @cAviso)
			IF VALTYPE(oXML) == "O" 
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Valida estrutura do XML ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				aRetISXML	:=  ISXmlDanfe(oXML)
				IF aRetISXML[1]
				
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณ Divide objeto da XML para facilitar o Acesso aos dados ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					IF VALTYPE(XmlChildEx(oXML, "_NFEPROC")) == "O"     
						IF VALTYPE(XmlChildEx(oXML:_nfeproc, "_NFE")) == "O"
							oDANFE		:= oXML:_nfeproc:_NFe     
							lTpNfe		:= .T.   
						ENDIF
					ELSEIF VALTYPE(XmlChildEx(oXML, "_ENVINFE")) == "O"
						IF VALTYPE(XmlChildEx(oXML:_ENVINFE, "_NFE")) == "O"
							oDANFE		:= oXML:_ENVINFE:_NFe
							lTpNfe		:= .T.
						ENDIF 			                                  
					ELSEIF VALTYPE(XmlChildEx(oXML, "_NFE")) == "O"
						oDANFE		:= oXML:_NFe
						lTpNfe		:= .T.	
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณ Tratativa para leitura de CTe ณ
					//ณ Jonatas Oliveira - 27/07/2012 ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					ELSEIF VALTYPE(XmlChildEx(oXML, "_CTEPROC")) == "O"
						IF VALTYPE(XmlChildEx(oXML:_cteproc, "_CTE")) == "O"
							oDANFE		:= oXML:_cteproc:_CTe     
							lTpCte		:= .T.	   
						ENDIF  	
						
					ENDIF
					
					IF !lTpCte//VALTYPE(XmlChildEx(oXML, "_CTEPROC")) <> "O"										
						oEmitente	:= oDANFE:_InfNfe:_Emit
						oDest		:= oDANFE:_InfNfe:_DEST						
						oIdent		:= oDANFE:_InfNfe:_IDE
						oTotal		:= oDANFE:_InfNfe:_Total  
						oDet		:= oDANFE:_InfNfe:_Det 					                
					
					ELSEIF lTpCte
						oEmitente	:= oDANFE:_InfCTe:_Emit
						oDestCte	:= oDANFE:_InfCTe:_DEST
						//oDest		:= oDANFE:_InfCTe:_REM
						oIdent		:= oDANFE:_InfCTe:_IDE
						oTotal		:= oDANFE:_InfCTe:_VPREST  
						oDet		:= oDANFE:_InfCTe:_VPREST 					                
						oImpCte		:= oDANFE:_InfCTe:_Imp
						
						//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
						//ณ Tratativa referente ao Tomador      ณ
						//ณ responsแvel pelo pagamento do frete ณ
						//ณ Layout 1.03 de 03/08/2009– RS/SP/GO ณ
						//ณ Thiago Nascimento - 09/05/2014      ณ
						//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
						
						// cTomaTip, ref. TAG <Toma03> <Toma> </Toma> </Toma03> -- Tomador do servi็o de Transporte
						// <Toma> (0=Remetente,1-Expedidor,2-Recebedor,3-Destinatario,4-Outros)
						cTomaTip := iif( VALTYPE(XmlChildEx(oIdent,"_TOMA03")) == "O" , oIdent:_Toma03:_Toma:text , iif( VALTYPE(XmlChildEx(oIdent,"_TOMA3")) == "O" , oIdent:_Toma3:_Toma:text , nil ) )
						
						
						cMunOri		:= RIGHT(oIdent:_cMunIni:TEXT	, 5)
						cMunDes		:= RIGHT(oIdent:_cMunFim:TEXT	, 5)
						cUfOrig		:= RIGHT(oIdent:_UFIni:TEXT		, 5)
						cUfDest		:= RIGHT(oIdent:_UFFim:TEXT		, 5)
						
						
						// Frete pago pelo Remetente
						if cTomaTip == "0"
							oDest		:= oDANFE:_InfCTe:_REM
							
							// Frete pago pelo Expedidor/Emitente
						elseif cTomaTip == "1"
							oDest		:= oDANFE:_InfCTe:_Emit
							
							// Frete pago pelo Recebedor
						elseif cTomaTip == "2"
							oDest		:= oDANFE:_InfCTe:_RECEB
							
							// Frete pago pelo Destinatario - Regra Reversใo de FOB Zatix.
						elseif cTomaTip == "3"
							oDest		:= oDANFE:_InfCTe:_REM //oDANFE:_InfCTe:_DEST
							
							// Frete pago por Outros
						elseif Empty(cTomaTip) //Vazio ้ porque emitiu CTE usando a TAG <toma4>
							
							//Quando for outros o CTE terแ uma nova TAG <toma4>							
							cTomaTip := oIdent:_toma4:_toma:text
							
							// "4", c๓digo de outros tomador conforme Layout Versใo 1.03 de 03/08/2009 – RS/SP/GO
							if cTomaTip == "4"
								oDest := oIdent:_toma4
							endif
							
						endif						
					
					ENDIF 
					
					

				
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณ Verifica se existe informacao de Nota fiscal de Referencia  ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					IF !lTpCte//VALTYPE(XmlChildEx(oXML, "_NFEPROC")) == "O" .OR. VALTYPE(XmlChildEx(oXML, "_NFE")) == "O"   	
						IF VALTYPE(XmlChildEx(oDANFE:_InfNfe, "_COBR")) == "O"
							oCobr		:= oDANFE:_InfNfe:_Cobr
						ENDIF					
					
						IF VALTYPE(XmlChildEx(oDANFE:_INFNFE, "_INFADIC")) == "O"
							IF VALTYPE(XmlChildEx(oDANFE:_INFNFE:_InfAdic, "_INFCPL")) == "O"				
								cInfAdic	:= oDANFE:_InfNfe:_InfAdic:_infCpl:TEXT
							ENDIF
						ENDIF	                
					ELSE 	
						//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
						//ณ Tratativa para leitura de CTe ณ
						//ณ Jonatas Oliveira - 01/08/2012 ณ
						//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู         				
						IF VALTYPE(XmlChildEx(oDANFE:_INFCTE,"_COMPL")) == "O"	  
							IF VALTYPE(XmlChildEx(oDANFE:_INFCTE:_Compl, "_XOBS")) == "O"				
								cInfAdic	:= oDANFE:_InfCte:_Compl:_XOBS:TEXT			
		                    ENDIF 
						ENDIF 
					ENDIF						
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณ Verifica se existe informacoes adicionais ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					IF VALTYPE(XmlChildEx(oIdent, "_NFREF")) == "A"
						IF VALTYPE(XmlChildEx(oIdent:_NFREF[1], "_REFNFE")) == "O"				
							cChvRef	:= ALLTRIM(oIdent:_NFREF[1]:_REFNFE:TEXT)
						ENDIF
						
					ELSEIF VALTYPE(XmlChildEx(oIdent, "_NFREF")) == "O"
						IF VALTYPE(XmlChildEx(oIdent:_NFREF, "_REFNFE")) == "O"				
							cChvRef	:= ALLTRIM(oIdent:_NFREF:_REFNFE:TEXT)
						ENDIF
					ENDIF 					
					
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณ Tratamento necessario pois quando a Danfe possui somente     ณ
					//ณ um item, esta propriedade vem como objeto ao inves de array. ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					IF VALTYPE(oDet) == "O"
						oDet	:= {oDet}
					ENDIF
					
					
					aDadosArq	:= {}
					
					IF !lTpCte//VALTYPE(XmlChildEx(oXML, "_CTEPROC")) <> "O" 
						cChvNfe		:= ALLTRIM(oDANFE:_INFNFE:_ID:TEXT)			
						cChvNfe		:=  SUBSTR(cChvNfe,4,LEN(cChvNfe))  
						cTipoOper	:= alltrim(oIdent:_tpNF:TEXT)

					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณ Tratativa para leitura de CTe ณ
					//ณ Jonatas Oliveira - 01/08/2012 ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					ELSEIF lTpCte
						cChvNfe		:= ALLTRIM(oDANFE:_INFCTE:_ID:TEXT)			
						cChvNfe		:=  SUBSTR(cChvNfe,4,LEN(cChvNfe))  
						cTipoOper	:= alltrim(oIdent:_tpCTE:TEXT)
					
					ENDIF						
				
					
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณ Verifica se Tipo da Nota - Entrada ou Saida ณ
					//ณ Busca Empresa + Filial de destino da DANFE  ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู         
					//aEmpSai	:= fEmpFil(oEmitente:_CNPJ:TEXT)
					
					IF VALTYPE(XmlChildEx(oEmitente, "_CNPJ")) == "O"
						aEmpSai	:= fEmpFil(oEmitente:_CNPJ:TEXT)
					ELSEIF VALTYPE(XmlChildEx(oEmitente, "_CPF")) == "O"
						aEmpSai	:= 	fEmpFil(oEmitente:_CPF:TEXT)
					ENDIF
					
					IF lTpCte //|Tipo Arquivo
						aadd(aEntSai, "C")
						
					ELSEIF !EMPTY(aEmpSai[1])
						IF cTipoOper == "0"
							aadd(aEntSai, "E")
						ELSE
							aadd(aEntSai, "S")
						ENDIF
							
					ENDIF
					      
					
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณ No caso do destinatario, a tag pode ser CNPJ ou CPF ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					IF VALTYPE(XmlChildEx(oDest, "_CNPJ")) == "O"
						cDestCNPJ	:= oDest:_CNPJ:TEXT
					ELSEIF VALTYPE(XmlChildEx(oDest, "_CPF")) == "O"
						cDestCNPJ	:= 	oDest:_CPF:TEXT
					ENDIF					
					  
					aEmpEnt	:= fEmpFil(cDestCNPJ)
					
					IF lTpCte .AND. EMPTY(aEmpEnt[1])
						IF VALTYPE(XmlChildEx(oDestCte, "_CNPJ")) == "O"
							cCNPJCPF	:= oDestCte:_CNPJ:TEXT
						ELSEIF VALTYPE(XmlChildEx(oDestCte, "_CPF")) == "O"
							cCNPJCPF	:= 	oDestCte:_CPF:TEXT
						ENDIF	
						aEmpEnt	:= fEmpFil(cCNPJCPF)
					ENDIF
					
					
					 
					IF !EMPTY(aEmpEnt[1]) .and. !lTpCte
						IF !(cTipoOper == "0" .AND. LEN(aEntSai) > 0)
							aadd(aEntSai, "E")
						ENDIF
					ENDIF					
			
					IF len(aEntSai) > 0     
							                                               
						lDelArqTemp		:= .F.
						
						//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
						//ณ Realiza Loop para abranger Entrada e Saida.                                  ณ
						//ณ Este processo e necessario pois em Empresas de BPO e importado o XML de      ณ
						//ณSaida e Entrada, e no caso de NF de tranferencia de Filiais, um arquivo deveraณ
						//ณser importado como Entrada e como Saida                                       ณ
						//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
						FOR nI := 1 to Len(aEntSai)

							cTipArq		:= aEntSai[nI]
							
							IF LEN(aRet) < nI
								AADD(aRet, ACLONE(aRetModelo))
							ENDIF
							// ฑฑบRETORNO   ณ aRet { {<cTipo>, <lImport>, <cMsgErro>, <cChave>} }        บฑฑ							
							aRet[nI, 1]	:= "D"+cTipArq 
							aRet[nI, 4]	:= cChvNfe //| Chave da Danfe
							
							IF cTipArq == "S" /*.OR. (cTipoOper == "0" .AND. cTipArq == "E") */ .AND. !lTpCte//VALTYPE(XmlChildEx(oXML, "_CTEPROC")) <> "O"  
								
								IF !_lImpSai
									aRet[nI,3]	:= "Importa็ใo de nota fiscal de saํda Desabilitada."
									loop
								ENDIF 								
							
							
								aEmpFil		:= aEmpSai
								
								IF !lTpCte //VALTYPE(XmlChildEx(oXML, "_NFEPROC")) == "O" .OR. VALTYPE(XmlChildEx(oXML, "_NFE")) == "O"							   
									cNumNfe		:= STRZERO(VAL(oIdent:_NNF:TEXT),TAMSX3("F2_DOC")[1])
								ELSE
									cNumNfe		:= STRZERO(VAL(oIdent:_NCT:TEXT),TAMSX3("F2_DOC")[1])									
								ENDIF                                                                 
								
								cCnpj  		:= cDestCNPJ
								cRazao 		:= oDest:_XNOME:TEXT  

								IF cTipoOper == "0" .AND. (cTipArq == "E" .OR.cTipArq == "C")//|Tipo Arquivo
									cPathDest	:= cPathEnt
								ELSE
									cPathDest	:= cPathSai																	
								ENDIF
							
							ELSEIF cTipArq == "E"  .OR. cTipArq == "C"  //|Tipo Arquivo
							
								if !_lImpEnt
									aRet[nI,3]	:= "Importa็ใo de nota fiscal de entrada Desabilitada."	
								endif
							
								aEmpFil		:= aEmpEnt                     
								
								IF lTpNfe//VALTYPE(XmlChildEx(oXML, "_NFEPROC")) == "O" .OR. VALTYPE(XmlChildEx(oXML, "_NFE")) == "O"							   
									cNumNfe		:= STRZERO(VAL(oIdent:_NNF:TEXT),TAMSX3("F1_DOC")[1])
								ELSEIF lTpCte
									cNumNfe		:= STRZERO(VAL(oIdent:_NCT:TEXT),TAMSX3("F1_DOC")[1])																	
								ENDIF
	
								//cCnpj		:= oEmitente:_CNPJ:TEXT
								IF VALTYPE(XmlChildEx(oEmitente, "_CNPJ")) == "O"
									cCnpj	:= oEmitente:_CNPJ:TEXT
								ELSEIF VALTYPE(XmlChildEx(oEmitente, "_CPF")) == "O"
									cCnpj	:= 	oEmitente:_CPF:TEXT
								ENDIF
								cRazao		:= oEmitente:_XNOME:TEXT
								cPathDest	:= cPathEnt						
							ENDIF
							
						                                                  
//							IF (Empty(xFilial("Z10")) .Or. cNumEmp = aEmpFil[1]+aEmpFil[2])   // Alterado por Eduardo Felipe em 10/06/14 - Quando tabela for exclusiva, nใo importar arquivo xml de outra empresa e filial na filial corrente.
														
							//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
							//ณ Verifica se a Nota Jแ foi Importada ณ
							//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
							Z10->(DBSETORDER(1))	//| Z10_FILIAL, Z10_CHVNFE, R_E_C_N_O_, D_E_L_E_T_
							IF Z10->(!DBSEEK(XFILIAL("Z10")+cChvNfe+aEntSai[nI],.F.))   
	
								//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
								//ณ Move Arquivo para Pasta Importado renomeando o arquivo ณ
								//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
								IF FILE(cFullPath)
									IF __CopyFile(cFullPath, cPathDest+cNomeArq)
										lDelArqTemp	:= .T.
									ENDIF								
								ENDIF
								
							
								IF FILE(cPathDest+cNomeArq)	//| Verifica se o arquivo foi copiado com sucesso.						
								
									nValFret	:= 0
									/*
                                   	IF !lTpCte                     
                                   		IF VALTYPE(XmlChildEx(oXML, "_NFEPROC")) == "O"              	
	            							IF valtype(   oXML:_NFEPROC:_NFE:_INFNFE:_TRANSP:_MODFRETE ) == "O"
												cTpFrete	:= oXML:_NFEPROC:_NFE:_INFNFE:_TRANSP:_MODFRETE:TEXT  //| MOD Frete
											ENDIF
										ENDIF 	 	
    								ENDIF
    								*/
    								IF !lTpCte                     
                                   		IF VALTYPE(XmlChildEx(oXML, "_NFEPROC")) == "O"              	
	            							IF valtype(   oXML:_NFEPROC:_NFE:_INFNFE:_TRANSP:_MODFRETE ) == "O"
												cTpFrete	:= oXML:_NFEPROC:_NFE:_INFNFE:_TRANSP:_MODFRETE:TEXT  //| MOD Frete
											ENDIF
										ELSEIF VALTYPE(XmlChildEx(oXML, "_NFE")) == "O"
											IF valtype(   oXML:_NFE:_INFNFE:_TRANSP:_MODFRETE ) == "O"
												cTpFrete	:= oXML:_NFE:_INFNFE:_TRANSP:_MODFRETE:TEXT  //| MOD Frete
											ENDIF 
										ENDIF 	 	
    								ENDIF
									//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
									//ณ Busca tipo da Nota com base no CFOP ณ
									//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู									
									IF !lTpCte//VALTYPE(XmlChildEx(oXML, "_CTEPROC")) <> "O"	
										cTipoNF		:= U_CP01G03(cTipArq,oDet, cCnpj)                       
										                      										
										IF LEFT(oDANFE:_INFNFE:_VERSAO:TEXT,2) == "2." 
											dDtEmiss	:= oIdent:_dEmi:TEXT //ConvDate(oIdent:_DEMI:TEXT) 
										//ELSEIF LEFT(oDANFE:_INFNFE:_VERSAO:TEXT,2) == "3."
										ELSE
											//TRATAR 3.0 <dhEmi>2014-05-05T17:00:55-03:00</dhEmi>
											dDtEmiss	:= LEFT(oIdent:_dhEmi:TEXT,10)
										ENDIF 
										
										nVlrIcmT	:= VAL(oTotal:_ICMSTot:_VNF:TEXT)   
										IF valtype(   oTotal:_ICMSTot:_Vfrete ) == "O"//|Frete
											nValFret	:= VAL(oTotal:_ICMSTot:_VFRETE:TEXT)
    									ENDIF 
                                    ELSE  
										cTipoNF		:= U_CP01G03("E",oIdent:_Cfop:TEXT)                                             	                                    	
										dDtEmiss	:= SUBSTRING(oIdent:_dhEmi:TEXT,1,10) //ConvDate(oIdent:_DEMI:TEXT) 
										nVlrIcmT	:= VAL(oTotal:_VtPrest:TEXT)
										aEmpFil		:=  aEmpEnt
                                    ENDIF
                                    
                                    //IF U_cpToDate(dDtEmiss, 'YYYY-MM-DD','D') >= STOD("20150101") .AND. U_cpToDate(dDtEmiss, 'YYYY-MM-DD','D') <= STOD("20150331")  
		
										DBSELECTAREA("Z10")	
										RegToMemory("Z10",.T.)   
										M->Z10_FILIAL	:= xFilial("Z10")   // Alterado por Eduardo Felipe em 10/06/14 - Adicionar Filial.
										M->Z10_TIPARQ	:= cTipArq
										M->Z10_CHVNFE	:= cChvNfe
										M->Z10_NUMNFE	:= cNumNfe
										M->Z10_UFNFE	:= U_CP01G04(ALLTRIM(oIdent:_cUF:TEXT)) //| Busca Sigla do Estado					
										M->Z10_SERIE	:= oIdent:_SERIE:TEXT	
	//									M->Z10_DTNFE	:= U_cpToDate(oIdent:_dEmi:TEXT, 'YYYY-MM-DD','D') //ConvDate(oIdent:_DEMI:TEXT) 
										M->Z10_DTNFE	:= U_cpToDate(dDtEmiss, 'YYYY-MM-DD','D') //ConvDate(oIdent:_DEMI:TEXT) 
										M->Z10_TIPNFE	:= cTipoNF 
										M->Z10_CNPJ		:= cCnpj
										M->Z10_RAZAO	:= cRazao
	//									M->Z10_VLRTOT	:= VAL(oTotal:_ICMSTot:_VNF:TEXT)    
										M->Z10_VLRTOT	:= nVlrIcmT    									
										M->Z10_ARQUIV	:= cNomeArq  
										M->Z10_CODEMP	:= aEmpFil[1]
										M->Z10_CODFIL	:= aEmpFil[2] 
										IF !EMPTY(cChvRef)
											M->Z10_CHVREF	:= cChvRef
										ENDIF                         
										M->Z10_TIPOPE	:= cTipoOper
										M->Z10_NATOPE	:= oIdent:_natOp:TEXT
										M->Z10_TPFRET	:= cTpFrete
										M->Z10_VFRETE	:= nValFret			
										
										M->Z10_MUORIT	:= cMunOri
										M->Z10_MUDEST	:= cMunDes
										M->Z10_UFDEST   := cUfOrig
										M->Z10_UFORIT   := cUfDest	
														
										//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
										//ณ Cobr - Dados da Cobran็a ณ
										//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
										IF VALTYPE(oCobr) == "O"									
											IF VALTYPE(XmlChildEx(oCobr, "_FAT")) == "O"
												IF VALTYPE(XmlChildEx(oCobr:_Fat, "_NFAT")) == "O"
													M->Z10_FTNUM	:= ALLTRIM(oCobr:_Fat:_NFAT:TEXT)
												ENDIF
												IF VALTYPE(XmlChildEx(oCobr:_Fat, "_VORIG")) == "O"
													M->Z10_FTVORI	:= VAL(oCobr:_Fat:_VORIG:TEXT)
												ENDIF
												IF VALTYPE(XmlChildEx(oCobr:_Fat, "_VDESC")) == "O"
													M->Z10_FTVDES	:= VAL(oCobr:_Fat:_VDESC:TEXT)
												ENDIF											
												IF VALTYPE(XmlChildEx(oCobr:_Fat, "_VLIQ")) == "O"
													M->Z10_FTVLIQ	:= VAL(oCobr:_Fat:_VLIQ:TEXT)
												ENDIF
											ENDIF										
										ENDIF								
									
										
										BEGIN TRANSACTION      
										
										//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
										//ณ Grava Cabecalho ณ
										//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
										DBSELECTAREA("Z10")
									 	RECLOCK("Z10",.T.)
											For nY := 1 To Z10->(FCOUNT())
												FieldPut(nY, M->&(FieldName(nY)) )
											Next nY	  
										Z10->(MSUNLOCK())	
										
										//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
										//ณ Grava campos Memo do Cabecalho ณ
										//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
										IF !EMPTY(cInfAdic)
											dbselectarea("SYP")
											MSMM(,,,cInfAdic,1,,.T.,"Z10","Z10_CODADD")
										ENDIF 
										
										
										
										//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
										//ณ Grava informacoes das duplicatas ณ
										//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
										IF VALTYPE(oCobr) == "O"
											IF VALTYPE(XmlChildEx(oCobr, "_DUP")) == "O" .OR. VALTYPE(XmlChildEx(oCobr, "_DUP")) == "A"
												
												//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
												//ณ Tratamento necessario pois quando a Danfe possui somente                  ณ
												//ณ um item de duplicada, esta propriedade vem como objeto ao inves de array. ณ
												//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
												IF VALTYPE(XmlChildEx(oCobr, "_DUP")) == "O"
													aDuplic	:= {oCobr:_DUP}
												ELSE
													aDuplic	:= oCobr:_DUP
												ENDIF 
												          
												DBSELECTAREA("Z13")											
												FOR nDup := 1 to len(aDuplic)
												
													RegToMemory("Z13",.T.)
													lGrvDup	:= .F.
													M->Z13_FILIAL	:= xFilial("Z13")   // Alterado por Eduardo Felipe em 10/06/14 - Adicionar Filial.
													M->Z13_CHVNFE	:= M->Z10_CHVNFE
													M->Z13_TIPARQ	:= M->Z10_TIPARQ
													M->Z13_ITEM		:= STRZERO(nDup, 3)
													
													IF VALTYPE(XmlChildEx(aDuplic[nDup], "_NDUP")) == "O"
														lGrvDup			:= .T.
														M->Z13_DUPLIC	:= ALLTRIM(aDuplic[nDup]:_NDUP:TEXT)
													ENDIF 
													IF VALTYPE(XmlChildEx(aDuplic[nDup], "_DVENC")) == "O"
														lGrvDup			:= .T.
														M->Z13_DTVENC	:= STOD(STRTRAN(aDuplic[nDup]:_DVENC:TEXT, "-",""))
													ENDIF 
													IF VALTYPE(XmlChildEx(aDuplic[nDup], "_VDUP")) == "O"
														lGrvDup			:= .T.
														M->Z13_VALOR	:= VAL(aDuplic[nDup]:_VDUP:TEXT) 
													ENDIF												           
													
													//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
													//ณ Grava Duplicata ณ
													//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
													IF lGrvDup
													 	RECLOCK("Z13",.T.)
															For nY := 1 To Z13->(FCOUNT())
																FieldPut(nY, M->&(FieldName(nY)) )
															Next nY	  
														Z13->(MSUNLOCK())													
													ENDIF												
												NEXT nDup
											ENDIF
										ENDIF
	
										IF !lTpNfe 
											IF VALTYPE(XmlChildEx(ODANFE:_INFCTE:_REM,"_INFNFE")) == "A" .OR.  VALTYPE(XmlChildEx(ODANFE:_INFCTE:_REM,"_INFNFE")) == "O"
											
												//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
												//ณ Tratamento necessario pois quando a Danfe possui somente                  ณ
												//ณ um item de duplicada, esta propriedade vem como objeto ao inves de array. ณ
												//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
												IF VALTYPE(XmlChildEx(ODEST, "_INFNFE")) == "O"
													aFatRef	:= {ODEST:_INFNFE}
												ELSE
													aFatRef	:= ODEST:_INFNFE
												ENDIF
												
												DBSELECTAREA("Z14")
												Z14->(DBSETORDER(1))//Z14_FILIAL+Z14_CHVCTE+Z14_TIPARQ+Z14_ITEM
												IF Z14->(DBSEEK(XFILIAL("Z14")+M->Z10_CHVNFE+M->Z10_TIPARQ,.F.))  
													FOR nFat := 1 to len(aFatRef)
														
														RegToMemory("Z14",.T.)
														lGrvFat	:= .F.
														M->Z14_FILIAL	:= xFilial("Z14")   // Alterado por Eduardo Felipe em 10/06/14 - Adicionar Filial.
														M->Z14_CHVCTE	:= M->Z10_CHVNFE
														M->Z14_TIPARQ	:= M->Z10_TIPARQ
														M->Z14_ITEM		:= STRZERO(nFat, 3)
														IF VALTYPE(XmlChildEx(aFatRef[nFat], "_CHAVE")) == "O"
															M->Z14_CHVNFE	:= ALLTRIM(aFatRef[nFat]:_CHAVE:TEXT)
															M->Z14_FATURA	:= Substring(ALLTRIM(aFatRef[nFat]:_CHAVE:TEXT),26,9)
															lGrvFat := .T.
														ENDIF
														//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
														//ณ Grava NF's CTe  ณ
														//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
														IF lGrvFat
															RECLOCK("Z14",.T.)
															For nY := 1 To Z14->(FCOUNT())
																FieldPut(nY, M->&(FieldName(nY)) )
															Next nY
															Z14->(MSUNLOCK())
														ENDIF
													NEXT nFat             
												ENDIF	
											ENDIF
										ENDIF	     
										
										//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
										//ณ Preenche Itens ณ
										//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
										FOR nItem := 1 to LEN(oDet)	
		
											cNcm := ""
											cStatus	:= ""
	                                        
	/*                                        IF !lTpNfe 
												IF VALTYPE(XmlChildEx(oDet[nItem]:_PROD,"_NCM"))  == "O"
													cNcm := ALLTRIM(oDet[nItem]:_PROD:_NCM:TEXT)
												ENDIF 
											ENDIF         */
																											                             
											DBSELECTAREA("Z11")
											RegToMemory("Z11",.T.)  
											
											IF lTpNfe//VALTYPE(XmlChildEx(oXML, "_CTEPROC")) <> "O"                                 
												M->Z11_FILIAL	:= xFilial("Z10")   // Alterado por Eduardo Felipe em 10/06/14 - Adicionar Filial.
												M->Z11_TIPARQ	:= M->Z10_TIPARQ       
												M->Z11_CHVNFE	:= M->Z10_CHVNFE 
												M->Z11_NUMNFE	:= M->Z10_NUMNFE                    		
												M->Z11_SERIE	:= M->Z10_SERIE 
												M->Z11_CNPJ		:= M->Z10_CNPJ
												M->Z11_ITEM		:= val(oDet[nItem]:_nItem:TEXT)
												//|cCfSrvB
												//|cPrSrvB
												IF SUBSTRING(oDet[nItem]:_Prod:_CFOP:TEXT,2,3) $ cCfSrvB .AND. !EMPTY(cPrSrvB)
													M->Z11_CODPRO	:= ALLTRIM(cPrSrvB)
												ELSE
													M->Z11_CODPRO	:= oDet[nItem]:_Prod:_cProd:TEXT
												ENDIF 
												
												M->Z11_DESPRO	:= oDet[nItem]:_Prod:_xProd:TEXT
												M->Z11_UM		:= ALLTRIM(upper(oDet[nItem]:_Prod:_uCom:TEXT))
												M->Z11_QUANT	:= VAL(oDet[nItem]:_Prod:_qCom:TEXT)
												M->Z11_VLRUNI	:= VAL(oDet[nItem]:_Prod:_vUnCom:TEXT)
												M->Z11_VLRTOT	:= VAL(oDet[nItem]:_Prod:_vProd:TEXT)
												M->Z11_CFOP		:= oDet[nItem]:_Prod:_CFOP:TEXT    
												M->Z11_POSIPI	:= ALLTRIM(oDet[nItem]:_PROD:_NCM:TEXT)
												M->Z11_CEAN		:= ALLTRIM(oDet[nItem]:_PROD:_CEAN:TEXT)
												
												IF VALTYPE(XmlChildEx(oDet[nItem]:_PROD,"_CEANTRIB")) <> 'U'   
													M->Z11_EANTRB	:= ALLTRIM( oDet[nItem]:_PROD:_CEANTRIB:TEXT )//|C - 20 |
												ENDIF 
												
												IF VALTYPE(XmlChildEx(oDet[nItem]:_PROD,"_UTRIB")) <> 'U'   
													M->Z11_UTRIB:= ALLTRIM( oDet[nItem]:_PROD:_UTRIB:TEXT )//|C - 2 |
												ENDIF 
												
												IF VALTYPE(XmlChildEx(oDet[nItem]:_PROD,"_QTRIB")) <> 'U'   
													M->Z11_QTRIB:= VAL( oDet[nItem]:_PROD:_QTRIB:TEXT )//|N - 12 - 4 |
												ENDIF 
												
												IF VALTYPE(XmlChildEx(oDet[nItem]:_PROD,"_VUNTRIB")) <> 'U'   
													M->Z11_VUNTIB:= VAL( oDet[nItem]:_PROD:_VUNTRIB:TEXT )//|N - 17 - 7 |
												ENDIF 
												
											ELSE     
											
												cCodProCte := 	U_CP01005G("11", "PRODTRANSP")
											
											//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
											//ณ Tratativa para leitura de CTe ณ
											//ณ Jonatas Oliveira - 01/08/2012 ณ
											//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู														    
												DBSELECTAREA("SB1")                                       	
												SB1->(DBSETORDER(1))
												SB1->(DBGOTOP())
												IF SB1->(DBSEEK(XFILIAL("SB1")+cCodProCte,.F.))
													M->Z11_FILIAL	:= xFilial("Z10")   // Alterado por Eduardo Felipe em 10/06/14 - Adicionar Filial.		
													M->Z11_TIPARQ	:= M->Z10_TIPARQ
													M->Z11_CHVNFE	:= M->Z10_CHVNFE 
													M->Z11_NUMNFE	:= M->Z10_NUMNFE                    		
													M->Z11_SERIE	:= M->Z10_SERIE 
													M->Z11_CNPJ		:= M->Z10_CNPJ
													M->Z11_ITEM		:= 1
													M->Z11_CODPRO	:= cCodProCte
													M->Z11_DESPRO	:= oIdent:_NatOp:TEXT
													M->Z11_UM		:= SB1->B1_UM
													M->Z11_QUANT	:= 1
													M->Z11_VLRUNI	:= nVlrIcmT
													M->Z11_VLRTOT	:= nVlrIcmT
													M->Z11_CFOP		:= oIdent:_Cfop:TEXT    
													M->Z11_POSIPI	:= ""
	                                           ELSE
													aRet[1,3]	:= "Produto nใo localizado: "+cCodProCte+" " 
	                                           ENDIF
											ENDIF
																					
											IF !lTpCte
												IF VALTYPE(XmlChildEx(oDet[nItem]:_PROD,"_XPED")) == "O"
													M->Z11_NUMPC  := Replicate( "0", TAMSX3("C7_NUM")[1]- LEN(ALLTRIM(oDet[nItem]:_Prod:_xped:TEXT)) ) + ALLTRIM(oDet[nItem]:_Prod:_xped:TEXT)//ALLTRIM(oDet[nItem]:_Prod:_xped:TEXT)
												ENDIF 	
												
												IF VALTYPE(XmlChildEx(oDet[nItem]:_PROD,"_NITEMPED")) == "O"
													M->Z11_ITEMPC	:=Replicate( "0", TAMSX3("C7_ITEM")[1]- LEN(ALLTRIM(oDet[nItem]:_Prod:_nItemPed:TEXT)) ) + ALLTRIM(oDet[nItem]:_Prod:_nItemPed:TEXT)											
												ENDIF 
											ENDIF 
											   
											//ฺฤฤฤฤฤฤฤฤฤฤฟ
											//ณ IMPOSTOS ณ
											//ภฤฤฤฤฤฤฤฤฤฤู
											IF VALTYPE(XmlChildEx(oDet[nItem], "_IMPOSTO")) == "O"
	
												//ฺฤฤฤฤฤฤฟ
												//ณ ICMS ณ
												//ภฤฤฤฤฤฤู
												IF VALTYPE(XmlChildEx(oDet[nItem]:_IMPOSTO, "_ICMS")) == "O"				
													nNodeImp := XmlChildCount(oDet[nItem]:_IMPOSTO:_ICMS)
													
													FOR nImp := 1 TO nNodeImp
													                          
														oImposto := XmlGetchild(oDet[nItem]:_IMPOSTO:_ICMS, nImp)
														
														IF VALTYPE(XmlChildEx(oImposto, "_ORIG")) == "O"
															M->Z11_ICORIG	:= ALLTRIM(oImposto:_ORIG:TEXT)
														ENDIF	
														IF VALTYPE(XmlChildEx(oImposto, "_CST")) == "O"
															M->Z11_ICCST 	:=	ALLTRIM(oImposto:_CST:TEXT)
														ENDIF												
														
														//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
														//ณ Base de Calculo e Valores ณ
														//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
														IF VALTYPE(XmlChildEx(oImposto, "_VICMS")) == "O" .AND.;
															VALTYPE(XmlChildEx(oImposto, "_VBC")) == "O" .AND.;
															VALTYPE(XmlChildEx(oImposto, "_PICMS")) == "O"
															
															IF val(oImposto:_VICMS:TEXT) > 0
																M->Z11_ICBC  	:= val(oImposto:_VBC:TEXT)
																M->Z11_ICALQ 	:= IF(val(oImposto:_PICMS:TEXT) > 99.99, 0, val(oImposto:_PICMS:TEXT)) 
																M->Z11_ICVLR 	:= val(oImposto:_VICMS:TEXT)
															ENDIF   
														ENDIF     
														
														//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
														//ณ Base de Calculo e Valores Subst. Tributaria ณ
														//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
														IF VALTYPE(XmlChildEx(oImposto, "_VICMSST")) == "O" .AND.;
															VALTYPE(XmlChildEx(oImposto, "_VBCST")) == "O" .AND.;
															VALTYPE(XmlChildEx(oImposto, "_PICMSST")) == "O"
															
															IF val(oImposto:_VICMSST:TEXT) > 0
																M->Z11_ICSTBC  	:= val(oImposto:_VBCST:TEXT)
																M->Z11_ICSTAL 	:= IF(val(oImposto:_PICMSST:TEXT) > 99.99, 0, val(oImposto:_PICMSST:TEXT)) 
																M->Z11_ICSTVL 	:= val(oImposto:_VICMSST:TEXT)
															ENDIF   
														ENDIF												
													NEXT nImp
												ENDIF										
												
												
												
												//ฺฤฤฤฤฤฟ
												//ณ IPI ณ
												//ภฤฤฤฤฤู
												IF VALTYPE(XmlChildEx(oDet[nItem]:_IMPOSTO, "_IPI")) == "O"
													IF VALTYPE(XmlChildEx(oDet[nItem]:_IMPOSTO:_IPI, "_IPITRIB")) == "O"
													
														oImposto := oDet[nItem]:_IMPOSTO:_IPI:_IPITRIB 
														
														IF VALTYPE(XmlChildEx(oImposto, "_CST")) == "O"
															M->Z11_IPICST	:= ALLTRIM(oImposto:_CST:TEXT)
														ENDIF
														
														IF 	VALTYPE(XmlChildEx(oImposto, "_VBC")) == "O" .AND.;
															VALTYPE(XmlChildEx(oImposto, "_PIPI")) == "O" .AND.;
															VALTYPE(XmlChildEx(oImposto, "_VIPI")) == "O"
	
															M->Z11_IPIBC 	:= val(oImposto:_VBC:TEXT)														        
															M->Z11_IPIVLR	:= val(oImposto:_VIPI:TEXT)	   
																													
															if val(oImposto:_PIPI:TEXT) <=  99.99
																M->Z11_IPIALQ	:= val(oImposto:_PIPI:TEXT)
															ELSE                                           
																M->Z11_IPIALQ	:= 0                                          
																aRet[nI,3]	:= "Aliquota de IPI invแlida: "+oImposto:_PIPI:TEXT															
															ENDIF      
															/*
															ELSE
																cStatus		:= "4"
																aRet[nI,3]	:= "Aliquota de IPI invแlida: "+oImposto:_PIPI:TEXT
															ENDIF
															*/
														ENDIF
													ENDIF												
												ENDIF 
												
												
												
												//ฺฤฤฤฤฤฟ
												//ณ PIS ณ
												//ภฤฤฤฤฤู   
												IF VALTYPE(XmlChildEx(oDet[nItem]:_IMPOSTO, "_PIS")) == "O"				
													nNodeImp := XmlChildCount(oDet[nItem]:_IMPOSTO:_PIS)
													
													FOR nImp := 1 TO nNodeImp
													                          
														oImposto := XmlGetchild(oDet[nItem]:_IMPOSTO:_PIS, nImp)
														
														IF VALTYPE(XmlChildEx(oImposto, "_CST")) == "O"
															M->Z11_PISCST 	:=	ALLTRIM(oImposto:_CST:TEXT)
														ENDIF												
														
														//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
														//ณ Base de Calculo e Valores ณ
														//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
														IF VALTYPE(XmlChildEx(oImposto, "_VBC")) == "O" .AND.;
															VALTYPE(XmlChildEx(oImposto, "_VPIS")) == "O" .AND.;
															VALTYPE(XmlChildEx(oImposto, "_PPIS")) == "O"
															
															IF val(oImposto:_VPIS:TEXT) > 0
																M->Z11_PISBC  	:= val(oImposto:_VBC:TEXT)
																M->Z11_PISALQ 	:= IF(val(oImposto:_PPIS:TEXT) > 99.99, 0, val(oImposto:_PPIS:TEXT)) 
																M->Z11_PISVLR 	:= val(oImposto:_VPIS:TEXT)
																
																EXIT //| Sai do Loop apos encontra valores
															ENDIF   
														ENDIF
													NEXT nImp
												ENDIF
												     
												
												
												//ฺฤฤฤฤฤฤฤฤฟ
												//ณ COFINS ณ
												//ภฤฤฤฤฤฤฤฤู
												IF VALTYPE(XmlChildEx(oDet[nItem]:_IMPOSTO, "_COFINS")) == "O"				
													nNodeImp := XmlChildCount(oDet[nItem]:_IMPOSTO:_COFINS)
													
													FOR nImp := 1 TO nNodeImp
													                          
														oImposto := XmlGetchild(oDet[nItem]:_IMPOSTO:_COFINS, nImp)
														
														IF VALTYPE(XmlChildEx(oImposto, "_CST")) == "O"
															M->Z11_CFCST 	:=	ALLTRIM(oImposto:_CST:TEXT)
														ENDIF												
														
														//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
														//ณ Base de Calculo e Valores ณ
														//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
														IF VALTYPE(XmlChildEx(oImposto, "_VBC")) == "O" .AND.;
															VALTYPE(XmlChildEx(oImposto, "_VCOFINS")) == "O" .AND.;
															VALTYPE(XmlChildEx(oImposto, "_PCOFINS")) == "O"
															
															IF val(oImposto:_VCOFINS:TEXT) > 0
																M->Z11_CFBC  	:= val(oImposto:_VBC:TEXT)
																M->Z11_CFALQ 	:= IF(val(oImposto:_PCOFINS:TEXT) > 99.99, 0, val(oImposto:_PCOFINS:TEXT)) 
																M->Z11_CFVLR 	:= val(oImposto:_VCOFINS:TEXT)
																
																EXIT //| Sai do Loop apos encontra valores
															ENDIF   
														ENDIF
													NEXT nImp
												ENDIF 
												
												       
												//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
												//ณ II - Imposto de Importacao ณ
												//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
												IF VALTYPE(XmlChildEx(oDet[nItem]:_IMPOSTO, "_II")) == "O"
													
													oImposto := oDet[nItem]:_IMPOSTO:_II
													
													IF 	VALTYPE(XmlChildEx(oImposto, "_VBC")) == "O"
														M->Z11_IIBC		:= val(oImposto:_VBC:TEXT)
													ENDIF												
													
													IF VALTYPE(XmlChildEx(oImposto, "_VDESPADU")) == "O"
														M->Z11_IIADUA	:= val(oImposto:_VDESPADU:TEXT)
													ENDIF
													
													IF VALTYPE(XmlChildEx(oImposto, "_VII")) == "O"
														M->Z11_IIVLR		:= val(oImposto:_VII:TEXT)
													ENDIF												
													
													IF VALTYPE(XmlChildEx(oImposto, "_VIOF")) == "O"
														M->Z11_IIIOF		:= val(oImposto:_VIOF:TEXT)
													ENDIF
												ENDIF                                                           
												
											//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
											//ณ Tratativa para leitura de CTe ณ
											//ณ Jonatas Oliveira - 01/08/2012 ณ
											//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู																				
											ELSEIF VALTYPE(oImpCte) == "O"																				
																										
												//ฺฤฤฤฤฤฤฟ
												//ณ ICMS ณ
												//ภฤฤฤฤฤฤู
												IF VALTYPE(XmlChildEx(oImpCte, "_ICMS")) == "O"
													nNodeImp := XmlChildCount(oImpCte:_ICMS)
													
													FOR nImp := 1 TO nNodeImp
														
														oImposto := XmlGetchild(oImpCte:_ICMS, nImp)
														
														IF VALTYPE(XmlChildEx(oImposto, "_ORIG")) == "O"
															M->Z11_ICORIG	:= ALLTRIM(oImposto:_ORIG:TEXT)
														ENDIF
														IF VALTYPE(XmlChildEx(oImposto, "_CST")) == "O"
															M->Z11_ICCST 	:=	ALLTRIM(oImposto:_CST:TEXT)
														ENDIF
														
														//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
														//ณ Base de Calculo e Valores ณ
														//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
														IF VALTYPE(XmlChildEx(oImposto, "_VICMS")) == "O" .AND.;
															VALTYPE(XmlChildEx(oImposto, "_VBC")) == "O" .AND.;
															VALTYPE(XmlChildEx(oImposto, "_PICMS")) == "O"
															
															IF val(oImposto:_VICMS:TEXT) > 0
																M->Z11_ICBC  	:= val(oImposto:_VBC:TEXT)
																M->Z11_ICALQ 	:= IF(val(oImposto:_PICMS:TEXT) > 99.99, 0, val(oImposto:_PICMS:TEXT))
																M->Z11_ICVLR 	:= val(oImposto:_VICMS:TEXT)
															ENDIF
														ENDIF
														
														//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
														//ณ Base de Calculo e Valores Subst. Tributaria ณ
														//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
														IF VALTYPE(XmlChildEx(oImposto, "_VICMSST")) == "O" .AND.;
															VALTYPE(XmlChildEx(oImposto, "_VBCST")) == "O" .AND.;
															VALTYPE(XmlChildEx(oImposto, "_PICMSST")) == "O"
															
															IF val(oImposto:_VICMSST:TEXT) > 0
																M->Z11_ICSTBC  	:= val(oImposto:_VBCST:TEXT)
																M->Z11_ICSTAL 	:= IF(val(oImposto:_PICMSST:TEXT) > 99.99, 0, val(oImposto:_PICMSST:TEXT))
																M->Z11_ICSTVL 	:= val(oImposto:_VICMSST:TEXT)
															ENDIF
														ENDIF
													NEXT nImp
												ENDIF
																						
											
											ENDIF              
											
											   
											DBSELECTAREA("Z11")
										 	RECLOCK("Z11",.T.)
												For nY := 1 To Z11->(FCOUNT())
													FieldPut(nY, M->&(FieldName(nY)))
												Next nY	  
											Z11->(MSUNLOCK())  
										
										NEXT nItem
	
										CONFIRMSX8()
										
										//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
										//ณ Altera Status caso ocorra inconsistencias ณ
										//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
										IF EMPTY(cStatus)
											aRet[nI,2]	:= .T.
											aRet[nI,3]	:= "" 
										ELSE
										 	RECLOCK("Z10",.F.)
												Z10->Z10_STATUS := cStatus
											Z10->(MSUNLOCK()) 										
											
											IF !EMPTY(aRet[nI,3])
												dbselectarea("SYP")
												MSMM(,,,aRet[nI,3],1,,.T.,"Z10","Z10_CODLOG")
											ENDIF										
										ENDIF
										
										END TRANSACTION
										
										aRet[nI,5]	:= Z10->(RECNO())		
										
										/*----------------------------------------
											07/06/2019 - Jonatas Oliveira - Compila
											Ponto de entrada para grava็ใo de informa็๕es
											complementares
											Nใo espera Retorno
										------------------------------------------*/
										IF EXISTBLOCK("CP0101FT")
											//aGeraNota	:= Execblock("CP0102OK",.F.,.F.,{@aCabecNfe, @aItensNFe})							
											aAreaZ10	:= Z10->(GetArea())
										
											U_CP0101FT(Z10->(RECNO()), oXML, cTomaTip)
											
											RestArea(aAreaZ10)
																						
										ENDIF							
				
										// ฑฑบRETORNO   ณ aRet { {<cTipo>, <lImport>, <cMsgErro>, <cChave>} }        บฑฑ																

									/*
									ELSE
										aRet[nI,3]	:= "Emissใo de NF fora do periodo de teste."
									ENDIF
									*/
								ELSE
									aRet[nI,3]	:= "Falha na Copia do Arquivo(2)."				
								ENDIF 
								
							ELSE                                            
								lRemovArq	:= .T.
								
								aRet[nI,3]	:= "Danfe Jแ importada."
							ENDIF
							/*ELSE
															
								aRet[1,3]	:= "Arquivo nใo pertence a Empresa "+Left(cNumEmp,2)+" e Filial "+Right(cNumEmp,2)+"." 
								
							ENDIF*/
						NEXT nI         

						//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
						//ณ Remove arquivo temporario ณ
						//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู						
						IF lDelArqTemp
							fErase(cFullPath) 
						endif
						
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณ Move Arquivo para Pasta Rejeitados    ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู					
					ELSE
						__CopyFile(cFullPath, cPathRej+cNomeArq)
										
						aRet[1,3]	:= "Empresa nใo cadastrada, CNPJs -> Emitente: "+oEmitente:_CNPJ:TEXT+" Destinatแrio: "+cDestCNPJ
					ENDIF
				ELSE

					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณ CANCELAMENTO DA DANFE - XML        ณ
					//ณ                                    ณ					
					//ณ Tratamento para XML de cancelamentoณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					aISXMLCanc	:=  ISXmlCanc(oXML)
					cPathDest	:= cPathRej
					IF aISXMLCanc[1]
						IF VALTYPE(XmlChildEx(oXML, "_PROCCANCNFe")) <> "O"	
							oCanDanfe	:= oXML:_procCancNFe:_cancNFe
							oRetCanNfe	:= oXML:_procCancNFe:_retCancNFe					               

						//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
						//ณ Tratativa para leitura de CTe ณ
						//ณ Jonatas Oliveira - 03/08/2012 ณ
						//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
						ELSE 
							oCanDanfe	:= oXML:_procCancCTe:_cancCTe
							oRetCanNfe	:= oXML:_procCancCTe:_retCancCTe					               						
						ENDIF 							          
					          
						IF VALTYPE(oCanDanfe) == "O"
							IF VALTYPE(XmlChildEx(oXML, "_PROCCANCNFe")) <> "O"	
								cChvNfe		:= ALLTRIM(oCanDanfe:_infCanc:_chNFe:TEXT)
								cJustif		:= ALLTRIM(oCanDanfe:_infCanc:_xJust:TEXT) 
								cProtCanc	:= ALLTRIM(oRetCanNfe:_infCanc:_nProt:TEXT)
								
								//| Tratamento para formatacao de Data e Hora
								dDtCan	:= alltrim(oRetCanNfe:_infCanc:_dhRecbto:TEXT)
							ELSE 

								//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
								//ณ Tratativa para leitura de CTe ณ
								//ณ Jonatas Oliveira - 03/08/2012 ณ
								//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
								cChvNfe		:= ALLTRIM(oCanDanfe:_infCanc:_chCTe:TEXT)
								cJustif		:= ALLTRIM(oCanDanfe:_infCanc:_xJust:TEXT) 
								cProtCanc	:= ALLTRIM(oRetCanNfe:_infCanc:_nProt:TEXT)
								
								//| Tratamento para formatacao de Data e Hora
								dDtCan	:= alltrim(oRetCanNfe:_infCanc:_dhRecbto:TEXT)
							ENDIF 
							
															
							cHrCan	:= RIGHT(dDtCan,8)							
							dDtCan	:= STOD(STRTRAN(LEFT(dDtCan,10),"-",""))

							aRet[1,1]	:= "DC"
							aRet[1,4]	:= cChvNfe //| Chave da Danfe
				                                     
				                                     
							//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
							//ณ Cancela Danfe de Entrada e de Saida ณ
							//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
							aEntSai	:= {"E","S","C"}  
							lDelArqCan	:= .F.						
							For nI := 1 to 2
								
								//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
								//ณ Verifica se a Nota Jแ foi Importada ณ
								//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
								DBSELECTAREA("Z10")
								Z10->(DBSETORDER(1))	//| Z10_FILIAL, Z10_TIPARQ, Z10_CHVNFE, R_E_C_N_O_, D_E_L_E_T_
								IF Z10->(DBSEEK(XFILIAL("Z10")+cChvNfe+aEntSai[nI],.F.))
								                                             
									IF EMPTY(Z10->Z10_ARQCAN)
										//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
										//ณ Move Arquivo para Pasta Importado renomeando o arquivo ณ
										//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
										__CopyFile(cFullPath, cPathDest+aEntSai[nI]+"_"+cNomeArq)
									
										IF FILE(cPathDest+cNomeArq)	//| Verifica se o arquivo foi copiado com sucesso.						
										
											//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
											//ณ Remove arquivo temporario ณ
											//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
											//fErase(cFullPath)
											lDelArqCan	:= .T.				
											                      
											    
											BEGIN TRANSACTION
												
												RECLOCK("Z10", .F.)   
													Z10->Z10_ARQCAN	:= cNomeArq
												Z10->(MSUNLOCK())
												                                
													                     
												//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
												//ณ Registra na tabela de Cancelamento ณ
												//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
												aDadosCan	:= {}     
												                                        
												AADD(aDadosCan, {"Z12_TIPARQ", Z10->Z10_TIPARQ})
												AADD(aDadosCan, {"Z12_CHVNFE", cChvNfe})
												AADD(aDadosCan, {"Z12_JUSCAN", cJustif})
												AADD(aDadosCan, {"Z12_DTCAN", dDtCan})
												AADD(aDadosCan, {"Z12_HRCAN", cHrCan})
												AADD(aDadosCan, {"Z12_PROCAN", cProtCanc})
											
												IF GrvCanc(aDadosCan)
													
													//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
													//ณ Chama Funcao para tratamento do Cancelamento ณ
													//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
													CancDanfe() 

													aRet[1,2]	:= .T.
													aRet[1,3]	:= "Cancelamento processado com sucesso"												
												ELSE
													DisarmTransaction()
													
													aRet[1,2]	:= .F.
													aRet[1,3]	:= "Falha ao processar cancelamento do XML"
												ENDIF
												
											END TRANSACTION
											
										ENDIF 
									ELSE        
										lRemovArq	:= .T.
										aRet[1,3]		:= "XML de Cancelamento ja processado para esta Danfe: "+cChvNfe
									ENDIF  
								
									//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
									//ณ Remove arquivo temporario ณ
									//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
									IF lDelArqCan
										fErase(cFullPath)
									ENDIF
									                                        
								ELSE
									aRet[1,3]	:= "XML de Cancelamento - Danfe nao encontrada: "+cChvNfe
								ENDIF
							NEXT nI 							
						ENDIF
					ELSE 						
						lRemovArq	:= .T.						
						aRet[1,3]		:= "XML fora do padra de DANFE | "+aRetISXML[2]					
					ENDIF
				ENDIF				
			ELSE                
				lRemovArq	:= .T.			
				aRet[1,3]		:= "Falha na Abertura do XML, ERRO:"+ALLTRIM(cErro)
			ENDIF					                  
		ELSE
			aRet[1,3]	:= "Falha na Copia do Arquivo."
		ENDIF
	ELSE
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Copia Arquivos para a Pasta Temp e Verifica se a Nota ja foi importada ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	                               
		
		cFullPath	:= ALLTRIM(cPathTemp+cNomeArq)
		IF cPathXML == cFullPath
			lRemovArq	:= .T.
		ENDIF
		aRet[1,3]		:= "Arquivo ja importado."
	ENDIF		
ELSE
	aRet[1,3]	:= "Arquivo nใo encontrado."
ENDIF  



//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Remove arquivo temporario ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
IF lRemovArq
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Move Arquivos Rejeitados ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	IF lMoveRej
		__CopyFile(cFullPath, cPathRej+cNomeArq)							
	ENDIF
						
	ferase(cFullPath)
ENDIF                                              
          
         /*
IF LEN(aRet) > 0   

	FOR nI := 1
	
	NEXT nI

	lGeraPreNF	:= .F. // U_CP01005G("11", "XMLGPNF")	//| Gera Pre-Nota apos importadar Danfe
	
ENDIF
*/

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Envia workflow com inconsist๊ncias encontradas. ณ
//ณ Somente envia caso XML  = Danfe                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//End Sequence        
	  	                           
Return(aRet)   



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CP01001B บAutor  ณ Augusto Ribeiro	 บ Data ณ  04/12/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Importar Arquivo XML Manualmente                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function CP01001B()     
Local cFile
Local lAuto			:= .F.
Local aArqXML		:= {}
Local aXmlFullPath	:= {}   
Local _cCodAnt
Local _cFilAnt

nImpXml	:= Aviso("Importar XML da Danfe",	" Selecione o arquivo ou pasta a ser importada."+EOL+;
											"Ao selecionar uma pasta, todos os arquivos com extensใo .xml serใo importados.",{"Arquivo", "Pasta", "E-Mail", "Motor Fiscal", "Cancelar"},3)
 											//"Ao selecionar uma pasta, todos os arquivos com extensใo .xml serใo importados.",{"Arquivo", "Pasta", "Server", "FTP", "E-Mail", "Cancelar"},3)
		
		
IF nImpXml == 1 //| Arquivo

	cFile := cGetFile('Arquivo XML|*.xml','Selecione arquivo',0,,.F.,GETF_LOCALHARD+GETF_NETWORKDRIVE,.F.)
	IF !EMPTY(cFile)
		aXmlFullPath	:= {cFile}
	ENDIF
	
ELSEIF nImpXml == 2 //| Pasta

	cFile	 := ALLTRIM(cGetFile('Pasta','Selecione a pasta',0,,.F.,GETF_LOCALHARD+GETF_RETDIRECTORY,.T.)	)

	IF !EMPTY(cFile)	
		aArqXML := Directory(cFile+"*.xml")		
		FOR nI := 1 TO LEN(aArqXML)    
			lAuto	:= .t.
			aadd(aXmlFullPath,cFile + alltrim(aArqXML[nI,1]) ) 
		
		NEXT nI
	ENDIF	       
/*	
ELSEIF nImpXml == 3 //| Server

	cFile	 := U_CP01005G("11", "XMLPATHSRV")	

	IF !EMPTY(cFile)	
		aArqXML := Directory(cFile+"*.xml")		
		FOR nI := 1 TO LEN(aArqXML)
			aadd(aXmlFullPath,cFile + alltrim(aArqXML[nI,1]) ) 
		
		NEXT nI
	ENDIF	  

ELSEIF nImpXml == 3 //| FTP

//	Processa( {|| U_CP0104FTP("FTP") }, "Processando...")
	Processa( {|| U_CP01004("FTP") }, "Processando...")    
*/		
ELSEIF nImpXml == 3 //| E-mails
	
	Processa( {|| U_CP01007() }, "Buscando E-mails...")
//	Processa( {|| U_CP01004() }, "Importando Arquivos...")
	Processa( {|| U_CP01004("DIR") }, "Importando Arquivos...")
	
	
ELSEIF nImpXml == 4 //| Motor Fiscal


		
	MSGRUN("Buscando Arquivos, Aguarde...", "Motor Fiscal NFE ...", {|| U_CP01MFXML(CFILANT,"NFE")	})
	MSGRUN("Buscando Arquivos, Aguarde...", "Motor Fiscal CTE ...", {|| U_CP01MFXML(CFILANT,"CTE")	})
	MSGRUN("Processando Arquivos, Aguarde...", "Motor Fiscal...", {|| U_CP01004("DIR")	})//|Move para pasta TEMP e processa a importacao
	
	
	
ENDIF  
                  
                  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Importa XML ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู
Processa({||  ImpDanfe(aXmlFullPath, lAuto) })		

Return()
           


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CP01001F บAutor  ณ Augusto Ribeiro	 บ Data ณ  29/03/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Visualiza/Manuten็ใo no Registro                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function CP01001F(cAlias,nReg,nOpc)
Local nOpcA     := 0
Local oDlg		:= Nil
Local oEncCabec	:= Nil
Local oGetItem 	:= Nil
Local aButtons	:= {}
Local aPosObj   := {} 
Local aObjects  := {}                        
Local aSize     := MsAdvSize( .T. )
Local bOk 		:= {|| GrvDados(oGetItem:aCols), oDlg:End() }
Local bCancel 	:= {|| oDlg:End() }
Local nCntFor	:= 0
Local nCampos	:= 0
Local aCpoEnc	:= {}
Local lGravou	:= .F.

//Private aHeader := {}
//Private aCols  	:= {}
Private aHdrItem := {}
Private aColsItem  	:= {}
Private bCampo	:= {|x| FieldName(x) }
Private aTela[0][0]
Private aGets[0]  
Private nZ11CODPRO,nZ11QUANT, nZ11ITEM, nZ11IPIALQ, nZ11NFORI, nZ11SERORI,  nZ11NLOCAL, nZ11NCFOP


IF Z10->Z10_STATUS $ '1/4' .OR. nOpc == 2
	DBSelectArea("Z10")
	RegToMemory(cAlias,nOpc == 3 .Or. nOpc == 6 )
	                                             
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Botao para exportar dados para EXCEL                    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If	FindFunction("RemoteType") .And. RemoteType() == 1
		aAdd(aButtons   , {"BAIXATIT",{|| U_CP0101DU()}, "Visualizar duplicatas", "Duplicatas"})	
		aAdd(aButtons   , {PmsBExcel()[1],{|| DlgToExcel({ {"ENCHOICE","Cabe็alho",aGets,aTela},{"GETDADOS",OemToAnsi("Itens"),aHdrItem,aColsItem}})},PmsBExcel()[2],PmsBExcel()[3]})
		IF !EMPTY(Z10->Z10_ARQCAN) 
			aAdd(aButtons   , {"VERNOTA",{|| U_CP01001G()}, "Visualizar inf. de Cancelamento", "XML Cancel"})	
		ENDIF
		aAdd(aButtons   , {"PEDIDO",{|| U_CP0101FA()}, "Visualizar Faturas Cte", "Faturas - CTE"})
		IF Z10->Z10_TIPARQ == "C" .AND. (nOpc == 3 .OR. nOpc == 4) 
			aadd(aButtons   , {"CTE",  {|| U_CP01TICTE()}, "Faturas - CTE", "Manuten็ใo Fatura CTE"}) // Usuแrio podera incluir titulo de CTE - Thiago Nascimento 03/02/2013
		ENDIF

		// Novo botใo de desmembramento de item - Thiago Nascimento 29/04/2014
/*		IF lMayDesmem .AND. Z10->Z10_TIPARQ <> "C" .AND. (nOpc == 3 .OR. nOpc == 4)
			aAdd(aButtons   , {"DESMITEM",{|| DESMITEM()}, "Nova Linha", "Desmembrar item"})
		ENDIF		
*/			
	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMonta aHeader e aCols dos itens do Contrato.			 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	MontaAcols("Z11",@aHdrItem,@aColsItem,"Z11_FILIAL+Z11_CHVNFE+Z11_TIPARQ",Z10->(Z10_FILIAL+Z10_CHVNFE+Z10_TIPARQ),nOpc==3,"Z11_ITEM","Z11_FILIAL|Z11_CHVNFE|Z11_NUMNFE|Z11_SERIE|Z11_CNPJ|Z11_TIPARQ")
	
	nZ11ITEM		:= aScan(aHdrItem,{|x| ALLTRIM(x[2])=="Z11_ITEM"})
	nZ11CODPRO		:= aScan(aHdrItem,{|x| ALLTRIM(x[2])=="Z11_CODPRO"})
	nZ11QUANT		:= aScan(aHdrItem,{|x| ALLTRIM(x[2])=="Z11_QUANT"})	
	nZ11IPIALQ		:= aScan(aHdrItem,{|x| ALLTRIM(x[2])=="Z11_IPIALQ"})		
	nZ11NUMPC		:= aScan(aHdrItem,{|x| ALLTRIM(x[2])=="Z11_NUMPC"})		
	nZ11ITPC		:= aScan(aHdrItem,{|x| ALLTRIM(x[2])=="Z11_ITEMPC"})		
	//nZ11NFORI	    := aScan(aHdrItem,{|x| ALLTRIM(x[2])=="Z11_NFORIG"})
	//nZ11SERORI	    := aScan(aHdrItem,{|x| ALLTRIM(x[2])=="Z11_SERORI"})
	//nZ11NLOCAL	    := aScan(aHdrItem,{|x| ALLTRIM(x[2])=="Z11_LOCAL"})	
	nZ11NCFOP	    := aScan(aHdrItem,{|x| ALLTRIM(x[2])=="Z11_CFOP"})	
	
	aSize := MsAdvSize()
	aObjects := {}
	aAdd( aObjects, { 100, 100, .T., .T. } )
	aAdd( aObjects, { 100, 100, .T., .T. } )
	
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )
	aPosEnc	:= {000,000,aPosObj[1,3]-aPosObj[1,1]-12,aPosObj[1,4]-aPosObj[1,2]-1}
	
	
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],00 to aSize[6],aSize[5] OF oMainWnd PIXEL
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณInformacoes do cabecalho do Arquivo.				ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 
	oEncCabec	:= MsMGet():New(cAlias,nReg,nOpc,,,,aCpoEnc,aPosObj[1],IIF(nOpc==2,NIL,{}),,,,,oDlg,,.T.,,,.F.)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMonta a GetDados.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                            
	//aCpoAlt	:= {"Z11_CODPRO", "Z11_IPIALQ","Z11_NUMPC","Z11_ITEMPC","Z11_LOCAL","Z11_CFOP"}
	aCpoAlt	:= {"Z11_CODPRO", "Z11_IPIALQ","Z11_NUMPC","Z11_ITEMPC","Z11_CFOP"}
	FOR nI := 1 TO LEN(aColsItem)	
		IF aColsItem[nI,nZ11QUANT] <= 0
			aadd(aCpoAlt, "Z11_QUANT")	
			EXIT
		ENDIF	
	Next nI
	
	//MsGetDados(): New ( < nTop>, < nLeft>, < nBottom>, < nRight>, < nOpc>, [ cLinhaOk], [ cTudoOk], [ cIniCpos], [ lDeleta], [ aAlter], [ nFreeze], [ lEmpty], [ nMax], [ cFieldOk], [ cSuperDel], [ uPar], [ cDelOk], [ oWnd], [ lUseFreeze], [ cTela] 
	//oGetItem := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"AllwaysTrue","AllwaysTrue","+Z11_ITEM",.F., aCpoAlt,,,len(aCols))
	
	//MsNewGetDados(): New ( [ nTop], [ nLeft], [ nBottom], [ nRight ], [ nStyle], [ cLinhaOk], [ cTudoOk], [ cIniCpos], [ aAlter], [ nFreeze], [ nMax], [ cFieldOk], [ cSuperDel], [ cDelOk], [ oWnd], [ aPartHeader], [ aParCols], [ uChange], [ cTela] ) --> Objeto	
	oGetItem := MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],IIF(ALTERA, GD_UPDATE, 0),"AllwaysTrue","AllwaysTrue","+Z11_ITEM",aCpoAlt,,len(aColsItem), /*[cFieldOk]*/, /*[ cSuperDel]*/, "EVAL({|| .F.})", /*[oWnd]*/, aHdrItem, aColsItem, /*[ uChange]*/, /*[ cTela]*/ )
	
	oDlg:lMaximized := .T.
	
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg , bOk , bCancel , , aButtons ) CENTERED  
ELSE
	Aviso("Acesso Negado", "Verifique o Status do XML",{"Voltar"},1)	
ENDIF

Return()  

 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GrvDados บAutor  ณ Augusto Ribeiro	 บ Data ณ  30/05/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Grava Dados do GetDados                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GrvDados(aColsItem)
Local aAreaZ11	:= GetArea("Z11")
Local nI  
Local lAltStatus	:= .F.

DBSELECTAREA("Z11")
Z11->(DBSETORDER(1))	//| Z11_FILIAL, Z11_CHVNFE, Z11_ITEM

FOR nI := 1 TO LEN(aColsItem)
	
	IF Z11->(DBSEEK(XFILIAL("Z11")+Z10->Z10_CHVNFE+Z10->Z10_TIPARQ+ALLTRIM(STR(aColsItem[nI,nZ11ITEM])),.F.))
		                 
		IF Z11->Z11_CODPRO <>  aColsItem[nI,nZ11CODPRO] .OR.;
			 Z11->Z11_QUANT <> aColsItem[nI,nZ11QUANT] .OR.;
			 Z11->Z11_IPIALQ <> aColsItem[nI,nZ11IPIALQ] .OR.;
			 Z11->Z11_NUMPC <> aColsItem[nI,nZ11NUMPC] .OR.;
			 Z11->Z11_ITEMPC <> aColsItem[nI,nZ11ITPC] .OR.;			 
 			 Z11->Z11_CFOP <> aColsItem[nI,nZ11NCFOP]				 		

			Reclock("Z11",.F.)
			
				Z11->Z11_CODPRO	:= aColsItem[nI,nZ11CODPRO] 
				Z11->Z11_NUMPC 	:= aColsItem[nI,nZ11NUMPC]  
				Z11->Z11_ITEMPC := aColsItem[nI,nZ11ITPC]
				//Z11->Z11_NFORIG := aColsItem[nI,nZ11NFORI] 
			 	//Z11->Z11_SERORI := aColsItem[nI,nZ11SERORI]
			 	//Z11->Z11_LOCAL  := aColsItem[nI,nZ11NLOCAL] 
			 	Z11->Z11_CFOP   := aColsItem[nI,nZ11NCFOP] 
				
				IF Z11->Z11_QUANT <= 0
					Z11->Z11_QUANT	:= aColsItem[nI,nZ11QUANT]
				ENDIF
				
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Corre็ใo do campo Aliq. do IPI quando invalida ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				IF Z11->Z11_IPIALQ <> aColsItem[nI,nZ11IPIALQ] 
					Z11->Z11_IPIALQ	:= aColsItem[nI,nZ11IPIALQ]
					lAltStatus	:= .T.					
				ENDIF
				                 
			Z11->(MSUNLOCK())			
		ENDIF
	ENDIF
	
NEXT nI
           
          
IF Z10->Z10_STATUS == "4" .AND. lAltStatus
	Reclock("Z10",.F.)
		Z10->Z10_STATUS := "1"                       
	Z10->(MSUNLOCK())			          
ENDIF
			
RestArea(aAreaZ11)
Return()



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ImpDanfe บAutor  ณ Augusto Ribeiro	 บ Data ณ  04/12/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Importa Danfe para Tabela Intermediaria                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function ImpDanfe(aPathXML, lAuto)   
Local aRetImp		:= {}
Local nRetImp
Local aRetPreNota	:= {}
Local nCount		:= 0
Local aRetNF		    
Local nI			:= 0 
Local cCFBYPASS		:= ALLTRIM(U_CP01005G("11", "CFPRENOTA"))
Local aCFBYPASS
Local aAreaZ11

Default lAuto 		:= .F.

Private _cFileLog	:= ""
Private _cLogPath	:= ""
Private _Handle		:= ""  


nTotArq	:= LEN(aPathXML)

IF nTotArq >= 1  
                    
	ProcRegua(nTotArq)	      
      
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Inicia Log ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤู
	U_cpLogTxt(1)	
	
	DBSELECTAREA("Z11")
	Z11->(DBSETORDER(1))
	
	FOR nI := 1 to nTotArq
	
		IncProc("Importando Arquivos... "+TRANSFORM(nI, "@e 999,999,999",)+" de "+TRANSFORM(nTotArq,"@e 999,999,999"))	
	                                                    
		U_cpLogTxt(2, Replicate("-",40)+EOL)		
		U_cpLogTxt(2, "ARQUIVO: "+aPathXML[nI]+EOL)	

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Importa Arquivo(s) para tabela intermediaria                      ณ
		//ณ                                                                   ณ
		//ณ U_CP01001A                                                        ณ
		//ณ aRet { {<cTipo>, <lImport>, <cMsgErro>, <cChave>, <nZ10Recno> } } ณ
		//ณ cTipo:  DE = DANFE ENTRADA	                                      ณ
		//ณ		DS = DANFE SAIDA                                              ณ
		//ณ		DC = DANFE XML CANCELAMENTO                                   ณ
		//ณ		ER = Erro, Falha importacao do arquivo                        ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		aRetImp	:= U_CP01001A(aPathXML[nI])		  
		
		FOR nRetImp := 1 TO LEN(aRetImp)
		                
			IF aRetImp[nRetImp, 1] $ "DE/DS/DC"
			
				/*----------------------------------------
					30/04/2019 - Jonatas Oliveira - Compila
					Atualiza Motor Fiscal
				------------------------------------------*/
				U_CP01MFST(Z10->Z10_CNPJ, Z10->Z10_CHVNFE, "INTEGRADO" , IIF( ALLTRIM(Z10->Z10_TIPARQ) == "C", "CTE", "NFE" ))
	                                                                 
				U_cpLogTxt(2, "TIPO: "+aRetImp[nRetImp, 1]+EOL)
				U_cpLogTxt(2, "CHAVE: "+aRetImp[nRetImp, 4]+EOL)
				U_cpLogTxt(2, "NOTA / SERIE: "+Z10->Z10_NUMNFE+" / "+Z10->Z10_SERIE+EOL)
				
				IF aRetImp[nRetImp, 2]
                     

					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณ Valida NF-e no automaticamente ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					IF _lVldNfe .AND. aRetImp[nRetImp, 1] $ "DE/DS" 
						Z10->(DBGOTO(aRetImp[nRetImp, 5]))
						U_CP01001V(1,.F.)
						
					ENDIF 

					U_cpLogTxt(2, "Arquivo Pr้-importado com Sucesso: "+aRetImp[nRetImp, 3]+EOL)
					
					
					/*----------------------------------------
						29/05/2019 - Jonatas Oliveira - Compila
						Verifica se CFOP da nota permite gerar 
						Pre-nota Automaticamente
					------------------------------------------*/
					If !EMPTY(cCFBYPASS) 
						aCFBYPASS := U_cpC2A(cCFBYPASS, "/")
					EndIf 
					
					aAreaZ11		:= Z11->(GetArea())
					Z11->(DBGOTOP())
					
					IF Z11->(DBSEEK(Z10->( Z10_FILIAL + Z10_CHVNFE ))) .AND. aRetImp[nRetImp, 1] == "DE"
						IF ASCAN(aCFBYPASS, RIGHT(ALLTRIM(Z11->Z11_CFOP),3) ) > 0 
							_lGeraPreNF := .T.
						ENDIF 
					ENDIF 
					
					RestArea(aAreaZ11)
					                  
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณ Gera Pre-Nota ou Pedido de Venda automaticamente ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					aRetNF	:= {.F., ""}
					if (_lGeraPreNF .and. aRetImp[nRetImp, 1] == "DE") .OR.;
						(_lGeraPV .and. aRetImp[nRetImp, 1] == "DS")
					   
						aRetNF	:= U_CP01001C(lAuto)                         
						U_cpLogTxt(2, "LOG:"+aRetNF[2]+EOL)													
					ENDIF
					
				ELSE
					U_cpLogTxt(2, "LOG:"+aRetImp[nRetImp, 3]+EOL)
				ENDIF
			ELSEIF aRetImp[nRetImp, 1] == "ER"
				U_cpLogTxt(2, "LOG:"+aRetImp[nRetImp, 3]+EOL)
			ENDIF
			
			_lGeraPreNF  := U_CP01005G("11", "XMLGPNF")
			
		NEXT nRetImp
				
	NEXT nI  
	U_cpLogTxt(3)
ENDIF      



Return()

   




/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CP01001C บAutor  ณ Augusto Ribeiro	 บ Data ณ  05/12/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Chama funcao que gera a Pre-Nota                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function CP01001C(lAuto)
Local aRetImp	:= {.F.,""} 
Local lGeraNF	:= .F.
Local lAuto  
Local cLogReg	:= ""
Local lVdPreNt 	:= U_CP01005G("10", "VLDSEF")	//Valida XML no Sefaz                                                                                                                                              
Local lRetPad 	:= U_CP01005G("11", "RETORNF")	//Utiliza padrใo para retorno de NF?                                                                                                                       
Local aArea, aAreaZ10 , aAreaZ11
Local lExistSF1	:= .F. 
Local cCliFor 	:= ""
Local cLoja 	:= ""
Local cNumNFe6	:= ""

Local cCFBYPASS		:= ALLTRIM(U_CP01005G("11", "CFPRENOTA"))
Local aCFBYPASS
Local _lClassAut	:= .F. 


Private _cFileLog	 	:= ""
Private _cLogPath		:= ""
Private _Handle			:= "" 

Default lAuto	:= .F.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica a necessidade de validar XML No SEFAZ	ณ
//ณ exce็ใo a aus๊ncia do TSS. Thiago Nascimento 	ณ											
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lVdPreNt 

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Valida Novamente NF-e antes de gerar a Pr้-Nota ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	U_CP01001V(1)
	
	IF Z10->Z10_VALIDA == "2"
	
		lGeraNF	:= .T.
	
	ELSEIF Z10->Z10_VALIDA == "3"
	
		cLogReg	+= "Danfe invแlida."
	ELSE 
		cLogReg += " Por favor, verifique a valide a Danfe antes de executar esta fun็ใo."
	ENDIF
Else    
	lGeraNF := .T.
Endif		

	
IF lGeraNF		

    IF Z10->Z10_STATUS == "1"	//nใo importado
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Gera Pre-Nota ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		IF Z10->Z10_TIPNFE == "D" .And. lRetPad		//tipo de nota = devolu็ใo e retorno por padrใo	
		
			aArea		:= GetArea()
			aAreaZ10	:= Z10->(GetArea())
			aAreaZ11	:= Z11->(GetArea())
			
			//|Fun็ใo Padrใo para retornar do documento de Entrada|
			U_A103Devol()	
			
			/*----------------------------------------
				08/07/2019 - Jonatas Oliveira - Compila
				Verifica se a Nota Fiscal ja foi importada.
				1. Consulta o numero da NF com 9 digisto  
				2. Caso nao localizado, consulta novamente com 6 digitos
			------------------------------------------*/			
			
			RestArea(aAreaZ11)        
			RestArea(aAreaZ10)        
			RestArea(aArea)  
			
			lExistSF1	:= .F.
			DBSELECTAREA("SF1")
			SF1->(DBSETORDER(1))	//| F1_FILIAL, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, F1_TIPO
			
			DBSELECTAREA("SA1")
			SA1->(DBSETORDER(3)) //| A1_FILIAL, A1_CGC
			IF SA1->(DBSEEK(XFILIAL("SA1")+Z10->Z10_CNPJ,.F.))
			
				cCliFor 		:= SA1->A1_COD
				cLoja		:= SA1->A1_LOJA 
				 
				IF SF1->( DBSEEK(XFILIAL("SF1") + Z10->Z10_NUMNFE + Z10->Z10_SERIE + cCliFor + cLoja + Z10->Z10_TIPNFE,.F.) )
					lExistSF1	:= .T.
				ELSE
					cNumNFe6	:= ALLTRIM(STR(VAL(Z10->Z10_NUMNFE)))
					
					IF LEN(cNumNFe6) <= 6                                 
						cNumNFe6	:= STRZERO(VAL(Z10->Z10_NUMNFE),6)
						cNumNFe6	:= PADR(cNumNFe6, TAMSX3("F1_DOC")[1]," ")
						
						IF SF1->( DBSEEK(XFILIAL("SF1") + cNumNFe6 + Z10->Z10_SERIE + cCliFor + cLoja + Z10->Z10_TIPNFE,.F.) )
							lExistSF1	:= .T.
						ENDIF
					ENDIF
				ENDIF 	
			ELSE
				lExistSF1 := .F.
			ENDIF 	
			
			IF lExistSF1				            
				aRetImp	:= { .T.,""}
			ELSE
				aRetImp	:= { .F.,"Nota fiscal nao localizada. " + Z10->Z10_NUMNFE }
				cLogReg +=  "Falha na Gera็ใo do Documento de entrada: " +EOL + aRetImp[2] +EOL
				
			ENDIF 
			
      
						
			IF aRetImp[1]
				cLogReg :=  "Nota Gerada com Sucesso"+EOL

				//Status 5, nota Classificada.
				Reclock("Z10", .F.)
					Z10->Z10_STATUS := "5"
				Z10->(MSUNLOCK())
				/*----------------------------------------
					30/04/2019 - Jonatas Oliveira - Compila
					Atualiza Motor Fiscal
				------------------------------------------*/
				U_CP01MFST(Z10->Z10_CNPJ, Z10->Z10_CHVNFE, "NOTA CLASSIFICADA", IIF( ALLTRIM(Z10->Z10_TIPARQ) == "C", "CTE", "NFE" ))						
			ENDIF 
			

			                   
		ELSEIF Z10->Z10_TIPARQ == "E" .OR. Z10->Z10_TIPARQ == "C" //|Tipo Arquivo
			aRetImp	:= U_CP0102E(lAuto, Z10->Z10_CHVNFE,Z10->Z10_TIPARQ)
			IF aRetImp[1] 
				cLogReg +=  "Pre-Nota gerada com sucesso: "+EOL+aRetImp[2]+EOL
				DBSELECTAREA("SF1")
				SF1->(DBGOTO(aRetImp[3]))
				
				/*----------------------------------------
					30/04/2019 - Jonatas Oliveira - Compila
					Atualiza Motor Fiscal
				------------------------------------------*/
				U_CP01MFST(Z10->Z10_CNPJ, Z10->Z10_CHVNFE, "PRE-NOTA" , IIF( ALLTRIM(Z10->Z10_TIPARQ) == "C", "CTE", "NFE" ))
				
				
				If !EMPTY(cCFBYPASS) 
					aCFBYPASS := U_cpC2A(cCFBYPASS, "/")
				EndIf 
				
				aAreaZ11		:= Z11->(GetArea())
				Z11->(DBGOTOP())
				
				IF Z11->(DBSEEK(Z10->( Z10_FILIAL + Z10_CHVNFE )))
					IF ASCAN(aCFBYPASS, RIGHT(ALLTRIM(Z11->Z11_CFOP),3) ) > 0 
						_lClassAut := .T.
					ENDIF 
				ENDIF 
				
				RestArea( aAreaZ11 )
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Classifica Nota Fiscal automaticamente ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				IF (  _lDocEnt .OR. _lClassAut) .AND. Empty(SF1->F1_STATUS) //U_CP01005G("11", "GERADOCAUT")
					aRetImp	:= U_CP0108E(SF1->F1_DOC, SF1->F1_SERIE, SF1->F1_FORNECE, SF1->F1_LOJA)

					IF aRetImp[1]
						cLogReg +=  "Nota Gerada com Sucesso"+EOL
						
						/*----------------------------------------
							30/04/2019 - Jonatas Oliveira - Compila
							Atualiza Motor Fiscal
						------------------------------------------*/
						U_CP01MFST(Z10->Z10_CNPJ, Z10->Z10_CHVNFE, "NOTA CLASSIFICADA", IIF( ALLTRIM(Z10->Z10_TIPARQ) == "C", "CTE", "NFE" ))
						
					ELSE
						cLogReg +=  "Falha na Gera็ใo do Documento de entrada: "+EOL+aRetImp[2]+EOL
					ENDIF
				ELSEIF (_lDocEnt .OR. _lClassAut ) .AND. !EMPTY(aRetImp[3])
					
					IF !Empty(SF1->F1_STATUS)
						cLogReg +=  "Nota Gerada com Sucesso: " + aRetImp[2] +EOL 
						/*----------------------------------------
							30/04/2019 - Jonatas Oliveira - Compila
							Atualiza Motor Fiscal
						------------------------------------------*/
						U_CP01MFST(Z10->Z10_CNPJ, Z10->Z10_CHVNFE, "NOTA CLASSIFICADA", IIF( ALLTRIM(Z10->Z10_TIPARQ) == "C", "CTE", "NFE" ))
					ENDIF 
					
				ENDIF   
			ELSE
				 
				//cLogReg +=  "Falha na Gera็ใo do Documento de entrada: "+CRLF+aRetImp[2]+CRLF
				//substituํda linha acima pela abaixo [Mauro Nagata, www.compila.com.br, 20200303]
				cLogReg +=  aRetImp[2]+CRLF
			ENDIF
			
		ELSEIF Z10->Z10_TIPARQ == "S"                   
			aRetImp	:= U_CP0102S(lAuto, Z10->Z10_CHVNFE) 
			
			
			IF aRetImp[1] 
				cLogReg +=  "Pedido de Venda gerado com sucesso: "+EOL+aRetImp[2]+EOL
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Classifica Nota Fiscal automaticamente ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				IF _lDocSai //U_CP01005G("12", "GERADOCAUT")
					aRetImp	:= U_CP0108S(,Z10->Z10_CHVNFE)
					IF aRetImp[1]
						cLogReg +=  "Nota Gerada com Sucesso"+EOL
					ELSE
						cLogReg += "Falha na Gera็ใo da Nota Fiscal  de Saํda: "+EOL+aRetImp[2]+EOL
					ENDIF
				ENDIF 
			ELSE 
				cLogReg += "Falha na Gera็ใo da Nota Fiscal  de Saํda: "+EOL+aRetImp[2]+EOL
			
			ENDIF				
		ENDIF
		
		
		IF aRetImp[1]
//				MSGBOX("Pr้-Nota gerada com sucesso!", "Pr้-Nota Gerada", "INFO")
//				aRetImp[2]	:= "Pr้-Nota gerada com sucesso"+EOL+aRetImp[2]
		ELSE                                                
//				aRetImp[2]	:= "Falha na Gera็ใo da Pr้ Nota: "+EOL+aRetImp[2]
		ENDIF  
	ELSE
		cLogReg += "Verifique o Status da Danfe"
	ENDIF
	
ELSE
	cLogReg += "Por favor, verifique a valide a Danfe antes de executar esta fun็ใo."
ENDIF	         
        

aRetImp[2]	:= cLogReg

IF !(lAuto) .AND. aRetImp[1]
//	MSGBOX(aRetImp[2], "Sucesso", "INFO")
	
ELSEIF !(lAuto) .AND. !(aRetImp[1])		 
	Aviso("Falha ao Gerar a Pre-Nota", aRetImp[2],{"Voltar"},3,,,,.t.)		
ENDIF

//Grava log no cabe็alho da pre nota compila
Reclock("Z10", .F.)
	Z10->Z10_LOGINT := "Ocorrencia: " + cLogReg
    Z10->Z10_DTSE   := CtoD("//")
Z10->(MSUNLOCK())
	
Return(aRetImp)    

 
 
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CP01001D บAutor  ณ Augusto Ribeiro	 บ Data ณ  05/12/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Abre Site da Receita para validacao da Danfe               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบPARAMETROSณ nOpcVis: 1=Cons. NFE Completa, 2=Cons.Autorizacao          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function CP01001D(nOpcVis)
Local nOpcVis, nRetVld
Local cUrl	:= "https://www.nfe.fazenda.gov.br/portal/FormularioDePesquisa.aspx"                        

Default nOpcVis := 1
                    
    IF nOpcVis = 1  
		cUrl	:= "https://www.nfe.fazenda.gov.br/portal/FormularioDePesquisa.aspx?ChaveAcesso="+alltrim(Z10->Z10_CHVNFE)
    ELSEIF nOpcVis = 2
		cUrl	:= "https://www.nfe.fazenda.gov.br/portal/visualizacaoNFe/autorizacao/AutorizacaoUso.aspx?ChaveAcesso="+alltrim(Z10->Z10_CHVNFE)
    ENDIF	
    
    
	ShellExecute("open","iexplore.exe",cUrl,"", 1 ) 
	
	nRetVld	:= Aviso("Valida็ใo da DANFE", " A DANFE ้ vแlida?",{"SIM","NรO","SAIR"},1)
	
	IF nRetVld == 1
		RECLOCK("Z10",.F.)
			Z10->Z10_VALIDA := "2"
		Z10->(MSUNLOCK())
	ELSEIF nRetVld == 2
		RECLOCK("Z10",.F.)
			Z10->Z10_VALIDA := "3"
		Z10->(MSUNLOCK())
	ENDIF
	
/*
	IF WINEXEC("IEXPLORER.EXE "+cUrl) <> 0
		Aviso("Falha na Abertura do Browser",;
				" Nใo foi possํvel abrir o browser, por favor verifique suas permiss๕es com o "+;
				"administrador de redes. O SmartCliente deve ser executado com permiss๕es de a"+;
				"administrador."+;
				"URL: "+cUrl,{"Cancelar"},3, "Log de Erro")
	ENDIF
	*/
	
Return()  


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CP01001E บAutor  ณ Augusto Ribeiro	 บ Data ณ  08/03/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Copia XML do Servidor para Maquina do usuแrio              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function CP01001E()
Local cPathOrig	:= LOWER(ALLTRIM(U_CP01005G("11", "XMLOK"))) //| Path de destino dos arquivos
Local cPathDest
Local cNomeArq	:= ""
Local cFullPath	:= ""

cNomeArq	:= Lower(ALLTRIM(Z10->Z10_ARQUIV))
cFullPath	:= cPathOrig+cNomeArq


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDocumentos de Entrada ou CTE ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
IF Z10->Z10_TIPARQ == "E" .OR. Z10->Z10_TIPARQ == "C"	
	cPathOrig	:= LOWER(ALLTRIM(U_CP01005G("11", "XMLOK"))) //| Path de destino dos arquivos	

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDocumentos de Saidaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ELSE
	cPathOrig	:= LOWER(ALLTRIM(U_CP01005G("12", "XMLOK"))) //| Path de destino dos arquivos	
ENDIF


cPathDest := cGetFile('','Selecione Diretorio',1,,.F., nOR( GETF_LOCALHARD, GETF_NETWORKDRIVE, GETF_RETDIRECTORY ),.F., .T. )

IF !EMPTY(cPathDest)
	
	IF FILE(cFullPath)
		MSGRUN("Copiando Arquivo, Aguarde...", "Copiando...", {|| __CopyFile(cFullPath, cPathDest+cNomeArq)	})
	ELSE
		Aviso(" Arquivo Invแlido.","Arquivo de Origem nao encontrado"+EOL+cFullPath,{"SAIR"},1)
	ENDIF
ENDIF
Return  



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CP01001V บAutor  ณ Augusto Ribeiro	 บ Data ณ  05/12/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validacao da DANFE                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบPARAMETROSณ nOpcVld                                                    บฑฑ
ฑฑบ          ณ	 1=Validaca Automatica (Via WS)                           บฑฑ
ฑฑบ          ณ   2=Cons. NFE Completa - Abre Site da Receita              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function CP01001V(nOpcVld, lMsgRun)
Local nOpcVld                                          
Local aRetVld
Local cUrl	
Local lVldSef := U_CP01005G("10", "VLDSEF") 

Default nOpcVld := 2 
Default lMsgRun	:= .T.
        
	IF nOpcVld == 1                   
	
		IF Z10->Z10_VALIDA == "1"	//| Aguardando Validacao

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Valida Danfe junto ao Sefaz ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			IF lVldSef 
				IF lMsgRun
					MSGRUN("Verificando Validade da Danfe", "Sefaz...", {|| aRetVld	:= U_CP01G01(Z10->Z10_UFNFE, Z10->Z10_CHVNFE,Z10->Z10_TIPARQ)}) 
				ELSE    
					aRetVld	:= U_CP01G01(Z10->Z10_UFNFE, Z10->Z10_CHVNFE,Z10->Z10_TIPARQ)
				ENDIF
			ELSE
				aRetVld := {1,"",""}
			ENDIF 
			IF aRetVld[1] == 1 .OR. !lVldSef 
				RECLOCK("Z10",.F.)
					Z10->Z10_VALIDA := "2"
				Z10->(MSUNLOCK())


			ELSEIF aRetVld[1] == 4    
				RECLOCK("Z10",.F.)
					Z10->Z10_VALIDA := "4"
				Z10->(MSUNLOCK())			
				
			ELSEIF aRetVld[1] == 2    
			                                         
				cErroCan	:= ""
				cAvisoCan	:= ""
				oCanc := XmlParser(aRetVld[3],"_",@cErroCan, @cAvisoCan)
			
				IF VALTYPE(oCanc) == "O"    
					BEGIN TRANSACTION 
						cChvNfe		:= Z10->Z10_CHVNFE
						cJustif		:= ALLTRIM(oCanc:_RETCONSSITNFE:_RETCANCNFE:_INFCANC:_XMOTIVO:TEXT) 
						cProtCanc	:= ALLTRIM(oCanc:_RETCONSSITNFE:_RETCANCNFE:_INFCANC:_NPROT:TEXT)
						
						//| Tratamento para formatacao de Data e Hora
						dDtCan	:= alltrim(oCanc:_RETCONSSITNFE:_RETCANCNFE:_INFCANC:_dhRecbto:TEXT)
						
						cHrCan	:= RIGHT(dDtCan,8)							
						dDtCan	:= STOD(STRTRAN(LEFT(dDtCan,10),"-",""))
						
						                 
					
						//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
						//ณ Registra na tabela de Cancelamento ณ
						//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
						aDadosCan	:= {}     
						
						AADD(aDadosCan, {"Z12_CHVNFE", cChvNfe})
						AADD(aDadosCan, {"Z12_JUSCAN", cJustif})
						AADD(aDadosCan, {"Z12_DTCAN", dDtCan})
						AADD(aDadosCan, {"Z12_HRCAN", cHrCan})
						AADD(aDadosCan, {"Z12_PROCAN", cProtCanc})
					
						IF GrvCanc(aDadosCan)			
					
							RECLOCK("Z10",.F.)
								Z10->Z10_VALIDA := "3"
							Z10->(MSUNLOCK())
						ELSE
							DisarmTransaction()
						ENDIF      
					END TRANSACTION
				ENDIF
			ELSE    
				IF lMsgRun
					Aviso("Valida็ใo da DANFE", "Nใo foi possivel validar a Danfe"+EOL+aRetVld[2],{"SAIR"},1)
				ENDIF
			ENDIF
			
		ENDIF                    
    ELSEIF nOpcVld == 2
//		cUrl	:= "https://www.nfe.fazenda.gov.br/portal/consulta.aspx?tipoConsulta=completa&nfe="+alltrim(Z10->Z10_CHVNFE)
		cUrl	:= "https://www.nfe.fazenda.gov.br/PORTAL/consultaCompleta.aspx?tipoConteudo=XbSeqxE8pl8="+alltrim(Z10->Z10_CHVNFE)  

            		
   
		ShellExecute("open","iexplore.exe",cUrl,"", 1 ) 

    ENDIF
	
Return()   


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ NomeArq  บAutor  ณ Augusto Ribeiro	 บ Data ณ  03/12/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna somente o nome do arquivo + extensao Ex.: Arq.xml  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบPARAMETROSณ cFullPath = Caminho Completo do arquivo                    บฑฑ
ฑฑบRETORNO   ณ cRet	= Arquivo.ext                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function NomeArq(cFullPath)
Local cRet	:= ""
Local nFullPath	:= 0      
Local nI	

	IF !EMPTY(cFullPath)    
		cFullPath	:= ALLTRIM(cFullPath)
		nFullPath	:= LEN(cFullPath)
		
		FOR nI := 1 to nFullPath
			IF LEFT(RIGHT(cFullPath,nI),1) == "\"
				cRet	:= RIGHT(cFullPath,nI-1)
				EXIT
			ENDIF					
		NEXT nI	    
		
		IF EMPTY(cRet)
			cRet	:= cFullPath
		ENDIF
	ENDIF 

Return(cRet)     


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCP01001G  บAutor  ณAugusto Ribeiro     บ Data ณ 04/12/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Visualiza informacoes do XML de Cancelamento               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function CP01001G()
Local cAux	:= cCadastro

cCadastro	:= "XML de Cancelamento"

DBSELECTAREA("Z12")
Z12->(DBSETORDER(1))
IF Z12->(DBSEEK(XFILIAL("Z12")+Z10->Z10_CHVNFE,.F.))
	AxVisual("Z12",Z12->(RECNO()),2)
ELSE
	msgbox("Informacoes de cancelamento nใo encontrada", "Registro nใo encontrado", "ALERT")
ENDIF
 
cCadastro	:= cAux

Return                                                                                                    
         



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCP01001H  บAutor  ณAugusto Ribeiro     บ Data ณ 30/05/2011  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validacao periodica da validade na Danfe                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบParametrosณcCodEmp, cCodFil                                            บฑฑ
ฑฑบ          ณnDias                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function CP01001H(aParam)
Local cAux		:= cCadastro
Local aParam
Local dDataIni   
Local cQuery	:= ""  
Local cDest		:= LOWER(ALLTRIM(U_CP01005G("11", "DESTPNF")))  

Default aParam	:= {"01","01",2}
   
IF LEN(aParam) == 3
	IF !EMPTY(aParam[1]) .AND. !EMPTY(aParam[2]) .AND. !EMPTY(aParam[3])
	  
		PREPARE ENVIRONMENT EMPRESA aParam[1] FILIAL aParam[2]
		 
			DBSELECTAREA("Z10")

			dDataIni	:= dDataBase - 	aParam[3]
			
			cQuery	:= " SELECT  R_E_C_N_O_ as Z10_RECNO "
			cQuery	+= " FROM "+RetSqlName("Z10")+" Z10 "
			cQuery	+= " WHERE Z10_FILIAL = '"+XFILIAL("Z10")+"' "
			cQuery	+= " AND Z10_CODEMP = '"+aParam[1]+"' "
			cQuery	+= " AND Z10_CODFIL = '"+aParam[2]+"' "
			cQuery	+= " AND Z10_DTNFE >= '"+DTOS(dDataIni)+"' "
			cQuery	+= " AND Z10.D_E_L_E_T_ = '' "
			
			
			cQuery	:= ChangeQuery(cQuery)
			TcQuery cQuery New Alias "TZ10"	                  
			  
			WHILE TZ10->(!EOF())			
			                              
				Z10->(DBGOTO(TZ10->Z10_RECNO))
				
				IF Z10->Z10_VALIDA <> "3"
					
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณ Valida Danfe no Sefaz ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					U_CP01001V(1)
					IF Z10->Z10_STATUS == '2' .AND. Z10->Z10_VALIDA <> "2"

						//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
						//ณ Envia WF informando do cancelamento da Danfe ณ
						//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
						U_CP0101WC(Z10->Z10_CHVNFE, cDest)						
					ENDIF				
				ENDIF			
											
				TZ10->(DBSKIP())
			ENDDO
			
			TZ10->(DBCLOSEAREA())
	
		
		RESET ENVIRONMENT
	
	ENDIF
ENDIF                     

Return


               
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCP01001L  บAutor  ณAugusto Ribeiro     บ Data ณ 04/12/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria uma janela contendo a legenda da mBrowse ou retorna a บฑฑ
ฑฑบ          ณpara o BROWSE.                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/                                          
User Function CP01001L(nReg)
Local xRet
                      
Local aLegenda  := 	{ 	{ "BR_LARANJA" 	,"Aguard. Valida็ใo"		   	},; 
                        { "BR_AZUL"		,"NF-e Vแlida"	  				},;
                        { "BR_VERMELHO" ,"NF-e Invแlida"   				},;
                        { "BR_AMARELO"	,"NF-e Cancelada"				},;                        
                        { "BR_VERDE_ESCURO"	,"Pr้-Nota/Ped.Venda Gerado"},;
                        { "BR_VERDE"	,"Nota Gerada" 					},;                        
                        { "BR_PRETO"	,"Inconsistencia de Valores"	},;
                        { "BR_MARROM"	,"Arq. Desconsiderado"			},;
                        { "BR_BRANCO"	,"Cte Remetente"				},;
                        { "BR_PINK"		,"Verifique Status Sefaz"		},;
                        { "BR_VIOLETA"  ,"Nota de Devolu็ใo"            }}
                        
Local xRet := .T.

If	nReg = Nil	// Chamada direta da funcao onde nao passa, via menu Recno eh passado
	xRet := {}
	
Aadd(xRet, { 'Z10->Z10_STATUS == "1" .AND. Z10->Z10_VALIDA $ ("123") .AND. EMPTY(Z10->Z10_ARQCAN) .AND. Z10->Z10_TIPNFE == "D"'    , aLegenda[11][1] } )
Aadd(xRet, { 'Z10->Z10_STATUS == "1" .AND. Z10->Z10_VALIDA == "1" .AND. EMPTY(Z10->Z10_ARQCAN)'	, aLegenda[1][1] } )
Aadd(xRet, { 'Z10->Z10_STATUS == "1" .AND. Z10->Z10_VALIDA == "2" .AND. EMPTY(Z10->Z10_ARQCAN)'	, aLegenda[2][1] } )
Aadd(xRet, { 'Z10->Z10_STATUS == "1" .AND. Z10->Z10_VALIDA == "3" .AND. EMPTY(Z10->Z10_ARQCAN)'	, aLegenda[3][1] } )
Aadd(xRet, { 'Z10->Z10_VALIDA == "4" '	, aLegenda[4][1] } )	
Aadd(xRet, { 'Z10->Z10_STATUS == "2" '	, aLegenda[5][1] } )   
Aadd(xRet, { 'Z10->Z10_STATUS == "5" '	, aLegenda[6][1] } )	
Aadd(xRet, { 'Z10->Z10_STATUS == "4" '	, aLegenda[7][1] } )	
Aadd(xRet, { 'Z10->Z10_STATUS == "3" '	, aLegenda[8][1] } )	
Aadd(xRet, { 'Z10->Z10_STATUS == "6" '	, aLegenda[9][1] } )
Aadd(xRet, { 'Z10->Z10_STATUS == "7" '	, aLegenda[10][1] } )	
	
Else
	BrwLegenda(cCadastro, "Legenda",aLegenda)
EndIf

Return(xRet)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CP01001R บAutor  ณ Augusto Ribeiro	 บ Data ณ  05/05/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Reprocessa Arquivo                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function CP01001R(lAuto)
Local cPathEnt		:= LOWER(ALLTRIM(U_CP01005G("11", "XMLOK"))) //| Path de destino dos arquivos - ENTRADA
Local cPathSai		:= LOWER(ALLTRIM(U_CP01005G("12", "XMLOK"))) //| Path de destino dos arquivos - SAIDA
Local cPathXML


IF Z10->Z10_STATUS == "1" .OR. Z10->Z10_STATUS == "4"
              
    begin transaction
    
    IF Z10->Z10_TIPARQ == "E" .OR. Z10->Z10_TIPARQ == "C"//|Tipo Arquivo
		cPathXML 	:= ALLTRIM(cPathEnt)+ALLTRIM(Z10->Z10_ARQUIV)
	ELSEIF Z10->Z10_TIPARQ == "S"	
		cPathXML 	:= ALLTRIM(cPathSai)+ALLTRIM(Z10->Z10_ARQUIV)	
	ENDIF
	                        
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ  Exclui o registro ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	IF U_CP0101DE(Z10->Z10_CHVNFE, Z10->Z10_TIPARQ)
	
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Importa XML ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู
		ImpDanfe({cPathXML})
	ENDIF     
	
	end transaction
ELSE     
	Aviso("Acesso Negado", "Verifique o Status do XML",{"Voltar"},1)	
ENDIF

Return()




/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CP0101DE บAutor  ณ Augusto Ribeiro	 บ Data ณ  05/05/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Deleta registros com base na chave passada.                บฑฑ
ฑฑบParametrosณ cChave = Chave Danfe								          บฑฑ
ฑฑบ          ณ cTipo = Tipo "E", "C"    						          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function CP0101DE(cChave, cTipo)
Local lRet := .F.

IF !EMPTY(cChave) .AND. !EMPTY(cTipo)

	DBSELECTAREA("Z10")
	//incluํda linha abaixo [Mauro Nagata, Compila, 20200211]
	DbSetorder(1)
	IF Z10->(DBSEEK(XFILIAL("Z10")+cChave+cTipo))
		lRet := .T.      
	                        
				 
		BEGIN TRANSACTION 
		
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Duplicatas ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤู
		DBSELECTAREA("Z13")
		Z13->(DBSETORDER(1)) //| Z13_FILIAL, Z13_CHVNFE, Z13_TIPARQ, Z13_ITEM
		IF Z13->(DBSEEK(Z10->(Z10_FILIAL+Z10_CHVNFE+Z10_TIPARQ)))
			WHILE Z13->(!EOF()) .AND. Z10->(Z10_FILIAL+Z10_CHVNFE+Z10_TIPARQ) == Z13->(Z13_FILIAL+Z13_CHVNFE+Z13_TIPARQ)
			                         
				RECLOCK("Z13",.F.)
					Z13->(DBDELETE())
				MSUNLOCK()
			     
				Z13->(DBSKIP())
			ENDDO
		ENDIF
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Registros de Cancelamento ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		DBSELECTAREA("Z12")
		Z12->(DBSETORDER(1)) //| Z12_FILIAL, Z12_CHVNFE		                              
		IF Z12->(DBSEEK(Z10->(Z10_FILIAL+Z10_CHVNFE)))
			RECLOCK("Z12",.F.)		
				Z12->(DBDELETE())		
			MSUNLOCK()
		ENDIF
		                 
		
		//ฺฤฤฤฤฤฤฤฟ
		//ณ Itens ณ
		//ภฤฤฤฤฤฤฤู
		DBSELECTAREA("Z11")
		Z11->(DBSETORDER(1)) //| Z11_FILIAL, Z11_CHVNFE, Z11_TIPARQ, Z11_ITEM
		IF Z11->(DBSEEK(Z10->(Z10_FILIAL+Z10_CHVNFE+Z10_TIPARQ)))
			WHILE Z11->(!EOF()) .AND. Z10->(Z10_FILIAL+Z10_CHVNFE+Z10_TIPARQ) == Z11->(Z11_FILIAL+Z11_CHVNFE+Z11_TIPARQ)
			              
				RECLOCK("Z11",.F.)			     
					Z11->(DBDELETE())					
				MSUNLOCK()
			     
				Z11->(DBSKIP())
			ENDDO
		ENDIF		

		//ฺฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Cabecalho ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤู
		DBSELECTAREA("Z10")
		RECLOCK("Z10",.F.)
			Z10->(DBDELETE())		
		MSUNLOCK()     
		               
		
		END TRANSACTION

			
	ENDIF
ENDIF


Return(lRet)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fEmpFil  บAutor  ณAugusto Ribeiro     บ Data ณ 04/12/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorno Empresa Filial do SM0 do CNPJ passado              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบParametrosณ cCNPJ                                                      บฑฑ
ฑฑบRetorno   ณ aRet := {cCodEmp, cCodFild}                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/  
Static Function fEmpFil(cCNPJ)
Local aRet		:= {"", ""}   
Local aRetAux	:= {}
Local aAreaSM0 
Local cEmpParam	:= ALLTRIM(U_CP01005G("11", "XMLEFIL"))
                                                     
IF !EMPTY(cCNPJ)           
	cCNPJ	:= ALLTRIM(cCNPJ)

	DBSELECTAREA("SM0")
	aAreaSM0 := SM0->(GetArea())
	
	IF ALLTRIM(SM0->M0_CGC) == cCNPJ .AND. (EMPTY(cEmpParam) .OR. SM0->(M0_CODIGO+M0_CODFIL) $ cEmpParam)
		aRet := {SM0->M0_CODIGO, SM0->M0_CODFIL}
	ELSE
		SM0->(DBGOTOP())  
		
		WHILE SM0->(!EOF())        

			IF ALLTRIM(SM0->M0_CGC) == cCNPJ  
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Tratamento para empresas que existam no parametro ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				IF EMPTY(cEmpParam) .OR. SM0->(M0_CODIGO+M0_CODFIL) $ cEmpParam
					aRet 	:= {SM0->M0_CODIGO, SM0->M0_CODFIL}			
					aRetAux	:= {}
					EXIT
				ELSE                                            
					IF EMPTY(aRetAux)
						aRetAux := {SM0->M0_CODIGO, SM0->M0_CODFIL}	
					ENDIF
				ENDIF
			ENDIF		    
		    
			SM0->(DBSKIP())
		ENDDO
	ENDIF   
	
	
	IF !EMPTY(aRetAux)
		aRet	:= aRetAux
	ENDIF
		
	RestArea(aAreaSM0)
ENDIF

Return(aRet)        



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ISXmlDanfeบAutor ณAugusto Ribeiro     บ Data ณ 29/03/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida se o objeto contem a estrutura da Danfe             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบParametrosณ oObjXml                                                    บฑฑ
ฑฑบRetorno   ณ lRet                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/  
Static Function ISXmlDanfe(oObjXml)
Local aRet		:= {.F., ""}
Local oDanfe


IF VALTYPE(oObjXml) == "O"
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Divide objeto da XML para facilitar o Acesso aos dados ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//	IF lTpNfeProc//VALTYPE(XmlChildEx(oObjXml, "_NFEPROC")) == "O"     
	IF VALTYPE(XmlChildEx(oObjXml, "_NFEPROC")) == "O"     
		IF VALTYPE(XmlChildEx(oObjXml:_nfeproc, "_NFE")) == "O"
			oDANFE		:= oObjXml:_nfeproc:_NFe        
		ELSE
			aRet[2]	:= "Node _NFE nใo encontrado"					
		ENDIF                                   
//	ELSEIF lTpNfe//VALTYPE(XmlChildEx(oObjXml, "_NFE")) == "O"
	ELSEIF VALTYPE(XmlChildEx(oObjXml, "_NFE")) == "O"
		oDANFE		:= oObjXml:_NFe

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Tratativa para leitura de CTe ณ
	//ณ Jonatas Oliveira - 27/07/2012 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//	ELSEIF lTpCte//VALTYPE(XmlChildEx(oObjXml, "_CTEPROC")) == "O"
	ELSEIF VALTYPE(XmlChildEx(oObjXml, "_CTEPROC")) == "O"
		IF VALTYPE(XmlChildEx(oObjXml:_cteproc, "_CTE")) == "O"
			oDANFE		:= oObjXml:_cteproc:_CTe        
		ELSE
			aRet[2]	:= "Node _CTe nใo encontrado"					
		ENDIF 
	ELSEIF 	VALTYPE(XmlChildEx(oObjXml, "_ENVINFE")) == "O"
		oDANFE		:= oObjXml:_ENVINFE:_NFe	 
	ELSE
	aRet[2]	:= "Node _NFEPROC e _NFE nใo encontrado"

	ENDIF

	
	IF empty(aRet[2])
		IF VALTYPE(XmlChildEx(oDANFE, "_INFNFE")) == "O"			
			IF VALTYPE(XmlChildEx(oDANFE:_InfNfe, "_EMIT")) <> "O"	
				aRet	:= {.F., "Node _INFNFE nใo encontrado"}
				Return(aRet)
			ENDIF			
			
			IF VALTYPE(XmlChildEx(oDANFE:_InfNfe, "_DEST")) <> "O"	
				aRet	:= {.F., "Node _DEST nใo encontrado"}
				Return(aRet)
			ENDIF			
			
			IF VALTYPE(XmlChildEx(oDANFE:_InfNfe, "_IDE")) <> "O"	
				aRet	:= {.F., "Node _IDE nใo encontrado"}
				Return(aRet)
			ENDIF			
			
			IF VALTYPE(XmlChildEx(oDANFE:_InfNfe, "_TOTAL")) <> "O"	
				aRet	:= {.F., "Node _TOTAL nใo encontrado"}
				Return(aRet)
			ENDIF        
			
			IF VALTYPE(XmlChildEx(oDANFE:_InfNfe, "_DET")) <> "O" .AND. VALTYPE(XmlChildEx(oDANFE:_InfNfe, "_DET")) <> "A"
				aRet	:= {.F., "Node _DET nใo encontrado"}
				Return(aRet)
			ENDIF
			
			aRet	:= {.T., ""}
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Tratativa para leitura de CTe ณ
		//ณ Jonatas Oliveira - 27/07/2012 ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		ELSEIF VALTYPE(XmlChildEx(oDANFE, "_INFCTE")) == "O"			
			IF VALTYPE(XmlChildEx(oDANFE:_InfCte, "_EMIT")) <> "O"	
				aRet	:= {.F., "Node _INFCTE nใo encontrado"}
				Return(aRet)
			ENDIF			

			IF VALTYPE(XmlChildEx(oDANFE:_InfCte, "_DEST")) <> "O"	
				aRet	:= {.F., "Node _DEST nใo encontrado"}
				Return(aRet)
			ENDIF			

			IF VALTYPE(XmlChildEx(oDANFE:_InfCte, "_IDE")) <> "O"	
				aRet	:= {.F., "Node _IDE nใo encontrado"}
				Return(aRet)
			ENDIF	  
					
			IF VALTYPE(XmlChildEx(oDANFE:_InfCte, "_VPREST")) <> "O"	
				aRet	:= {.F., "Node _VPREST nใo encontrado"}
				Return(aRet)
			ENDIF     			
/*
			IF VALTYPE(XmlChildEx(oDANFE:_InfNfe, "_DET")) <> "O" .AND. VALTYPE(XmlChildEx(oDANFE:_InfNfe, "_DET")) <> "A"
				aRet	:= {.F., "Node _DET nใo encontrado"}
				Return(aRet)
			ENDIF
*/			
			aRet	:= {.T., ""}

		ENDIF			
	ENDIF
ENDIF


Return(aRet)   
               


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ISXmlCancบAutor  ณAugusto Ribeiro     บ Data ณ 18/03/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida se o objeto contem a estrutura da XML de Cancelamentบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบParametrosณ oObjXml                                                    บฑฑ
ฑฑบRetorno   ณ {lRet, cMsgErro)                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/  
Static Function ISXmlCanc(oObjXml)
Local aRet		:= {.F., ""}
Local oCanDanfe


IF VALTYPE(oObjXml) == "O"
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Divede objeto da XML para facilitar o Acesso aos dados ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	IF VALTYPE(XmlChildEx(oObjXml, "_PROCCANCNFE")) == "O"     
		IF VALTYPE(XmlChildEx(oObjXml:_procCancNFe, "_CANCNFE")) == "O"
			oCanDanfe	:= oObjXml:_procCancNFe:_cancNFe
		ELSE
			aRet[2]	:= "Node _CANCNFE nใo encontrado"					
		ENDIF                                   
	ELSEIF VALTYPE(XmlChildEx(oObjXml, "_CANCNFE")) == "O"
		oCanDanfe	:= oObjXml:_cancNFe
	ELSE
		aRet[2]	:= "Node _PROCCANCNFE e _CANCNFE nใo encontrado"
	ENDIF


		
	IF empty(aRet[2])
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Valida Primeira Parte ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		IF VALTYPE(XmlChildEx(oCanDanfe, "_INFCANC")) == "O"			

			IF VALTYPE(XmlChildEx(oCanDanfe:_infCanc, "_CHNFE")) <> "O"
				aRet	:= {.F., "Node _CHNFE nใo encontrado"}
				Return(aRet)
			ENDIF
			
			IF VALTYPE(XmlChildEx(oCanDanfe:_infCanc, "_XJUST")) <> "O"
				aRet	:= {.F., "Node _XJUST nใo encontrado"}
				Return(aRet)
			ENDIF			
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Valida Segunda Parte ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			IF VALTYPE(XmlChildEx(oObjXml:_procCancNFe, "_RETCANCNFE")) == "O"
				IF VALTYPE(XmlChildEx(oObjXml:_procCancNFe:_retCancNFe, "_INFCANC")) == "O"
					IF VALTYPE(XmlChildEx(oObjXml:_procCancNFe:_retCancNFe:_infCanc, "_DHRECBTO")) == "O"
						aRet	:= {.T., ""}
					ENDIF			
				ENDIF
			ENDIF
			
		ENDIF
	ENDIF
ENDIF


Return(aRet)   


           

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CancDanfeบAutor  ณ Augusto Ribeiro	 บ Data ณ  18/04/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa Cancelamento da Danfe                             บฑฑ
ฑฑบ          ณ Z10 e Z12 Devem estar posicionados                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function CancDanfe() 
Local cDest		:= U_CP01005G("11", "WFNFCAN")


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤetเืเืฟ
//ณTIPO DE EMAIL                                                     ณ
//ณ    01    	ALERTA QUANTO A PROBLEMA NA IMPORTACAO XML P/ PRE-NOTA ณ
//ณ    02    	INFORMACAO DE NF E QUANTIDADE DE VOLUMES               ณ
//ณ    03    	INFORMACAO DE PVS DE AJUSTE DE DIFERENCAS A MENOR      ณ
//ณ    04    	INFORMACAO SOBRE DIFERENCAS DE QUANTIDADE A MAIOR      ณ
//ณ    05    	ALERTA SOBRE PRECO MENOR                               ณ
//ณ    06    	ALERTA DIVERGEN E NOTAS DE DEBITO P/ FORNEC E USUARIOS ณ
//ณ    07    	INFORMACAO SOBRE PVS AUTOM PEND P/ GERACAO NF/ENVIO    ณ
//ณ    08    	ALERTA DE NFE INTEGRADA E CANCELADA POSTERIORMENTE     ณ
//ณ    09    	ALERTA PELO NAO RECEB DE XML NFE INCL MANUAL CONT/EME  ณ
//ณ    10    	ALERTA QUANDO ENTRADA MANUAL                           ณ
//ณ    11    	INFORMACAO CONSULTA XML / DANFE PEND INTEGRACAO        ณ
//ณ    12    	INFORMACAO NOTA DE DEBITO DIFERENCA DE PRECO           ณ
//ณ    13    	INFORMACAO NOTA DE DEBITO DIFERENCA DE QUANTIDADE      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤetเืเืู



//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ		DEPARTAMENTO           ณ
//ณ    01    	COMPRAS        ณ
//ณ    02    	RECEB FISICO   ณ
//ณ    03    	RECEB FISCAL   ณ
//ณ    04    	LOGISTICA      ณ
//ณ    05    	FISCAL         ณ
//ณ    06    	FINANCEIRO     ณ
//ณ    07    	CONTROLADORIA  ณ
//ณ    08    	QUALIDADE      ณ
//ณ    09    	TRANSPORTE     ณ
//ณ    10    	ENGENHARIA     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู




                         
IF Z10->Z10_STATUS == '2'
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Envia Workflow de cancelamento ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	U_CP0101WC(Z10->(Z10_CHVNFE+Z10_TIPARQ), cDest, "")
ENDIF

Return()


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณMontaAcolsบAutor  ณAugusto Ribeiro     บ Data ณ 29/03/2011  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMonta o aHeader e aCols.                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณcAliasH    : Alias da tabela trabalhada.                    บฑฑ
ฑฑบ          ณaHeaderAux : Cabecalho do Get.                              บฑฑ
ฑฑบ          ณaColsAux   : Colunas do Get.                                บฑฑ
ฑฑบ          ณcCamChave  : Campos Chaves da tabela. Deve ser Concatenado. บฑฑ
ฑฑบ          ณcChave     : Chave que deve ser comparada a cCamChave.      บฑฑ
ฑฑบ          ณlInclui    : Indica se e uma inclusao ou nao.               บฑฑ
ฑฑบ          ณcCpoIncre  : Campo que deve ser auto incrementado.          บฑฑ
ฑฑบ          ณcOculta    : Campos que nao devem aparecer no cabecalho.    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function MontaAcols(cAliasAux,aHeaderAux,aColsAux,cCamChave,cChave,lInclui,cCpoIncre,cOculta)
           
Local	nUsado := 0                

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta o aHeader.                                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

aHeaderAux := {}
aColsAux   := {}

DBSelectArea("SX3")
SX3->(DBSetOrder(1))
SX3->(DBSeek(cAliasAux,.T.))

While (  SX3->(!Eof()) .And. SX3->X3_ARQUIVO == cAliasAux )
	
	If 	X3USO(SX3->X3_USADO) 		.And. ;
		cNivel >= SX3->X3_NIVEL		.And. ;
		!(AllTrim(SX3->X3_CAMPO)	$ cOculta )
		
		/*
		 aAdd(aHeaderAux,{ 	AllTrim(X3Titulo()),;
							SX3->X3_CAMPO,;
							SX3->X3_PICTURE,;
							SX3->X3_TAMANHO,;
							SX3->X3_DECIMAL,;
							SX3->X3_VALID,;
							SX3->X3_USADO,;
							SX3->X3_TIPO,;
							SX3->X3_F3,;
							SX3->X3_CONTEXT } )
		*/
		IF ALLTRIM(SX3->X3_CAMPO) == "Z11_CODPRO"
			aAdd(aHeaderAux,{ 	AllTrim(X3Titulo()),;
								SX3->X3_CAMPO,;
								"@S10" /*SX3->X3_PICTURE*/,;
								SX3->X3_TAMANHO,;
								SX3->X3_DECIMAL,;
								SX3->X3_VALID,;
								SX3->X3_USADO,;
								SX3->X3_TIPO,;
								SX3->X3_F3,;
								SX3->X3_CONTEXT } )
		
		Else
			aAdd(aHeaderAux,{ 	AllTrim(X3Titulo()),;
							SX3->X3_CAMPO,;
							SX3->X3_PICTURE,;
							SX3->X3_TAMANHO,;
							SX3->X3_DECIMAL,;
							SX3->X3_VALID,;
							SX3->X3_USADO,;
							SX3->X3_TIPO,;
							SX3->X3_F3,;
							SX3->X3_CONTEXT } )
		EndIf
 
	EndIf              
	
SX3->(DBSkip())
EndDo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta o aCols.                                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

nUsado := Len(aHeaderAux)
   
   aColsAux := {}
      
   DBSelectArea(cAliasAux)
   DBSetOrder(1)
   DBSeek(cChave)
   
   While !Eof() .And. &cCamChave==cChave

   	    aADD(aColsAux, Array(nUsado+1))
   	    
   	    For nX := 1 To nUsado
   	    	If (aHeaderAux[nX,10] != "V")
   	    		aColsAux[Len(aColsAux)][nX] := FieldGet(FieldPos(aHeaderAux[nX,2]))
   	    	Else
   	    		aColsAux[Len(aColsAux)][nX] := CriaVar(aHeaderAux[nX,2],.T.)
   	    	EndIf
   	    Next

   	    aColsAux[Len(aColsAux)][nUsado+1] := .F.
	
		DBSelectArea(cAliasAux)
	 	DBSkip()
   	EndDo

Return()


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CP01001W บAutor ณ Augusto Ribeiro	 บ Data ณ  11/05/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envia WF de Falha ao Gerar Pre-Nota                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function CP01001W(cChvDanfe, cLog)
Local cQuery 	:= "" 
Local lEnviaWF
Local cCodWF	:= ""  
Local cDest		:= U_EnvTipMail("01",{"01","02","03","04","10"}) 
Local aArea		:= GetArea()
Local aAreaZ10	:= Z10->(GetArea())
Local aAreaZ11	:= Z11->(GetArea())  


	            

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤetเืเืฟ
//ณTIPO DE EMAIL                                                     ณ
//ณ    01    	ALERTA QUANTO A PROBLEMA NA IMPORTACAO XML P/ PRE-NOTA ณ
//ณ    02    	INFORMACAO DE NF E QUANTIDADE DE VOLUMES               ณ
//ณ    03    	INFORMACAO DE PVS DE AJUSTE DE DIFERENCAS A MENOR      ณ
//ณ    04    	INFORMACAO SOBRE DIFERENCAS DE QUANTIDADE A MAIOR      ณ
//ณ    05    	ALERTA SOBRE PRECO MENOR                               ณ
//ณ    06    	ALERTA DIVERGEN E NOTAS DE DEBITO P/ FORNEC E USUARIOS ณ
//ณ    07    	INFORMACAO SOBRE PVS AUTOM PEND P/ GERACAO NF/ENVIO    ณ
//ณ    08    	ALERTA DE NFE INTEGRADA E CANCELADA POSTERIORMENTE     ณ
//ณ    09    	ALERTA PELO NAO RECEB DE XML NFE INCL MANUAL CONT/EME  ณ
//ณ    10    	ALERTA QUANDO ENTRADA MANUAL                           ณ
//ณ    11    	INFORMACAO CONSULTA XML / DANFE PEND INTEGRACAO        ณ
//ณ    12    	INFORMACAO NOTA DE DEBITO DIFERENCA DE PRECO           ณ
//ณ    13    	INFORMACAO NOTA DE DEBITO DIFERENCA DE QUANTIDADE      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤetเืเืู



//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ		DEPARTAMENTO           ณ
//ณ    01    	COMPRAS        ณ
//ณ    02    	RECEB FISICO   ณ
//ณ    03    	RECEB FISCAL   ณ
//ณ    04    	LOGISTICA      ณ
//ณ    05    	FISCAL         ณ
//ณ    06    	FINANCEIRO     ณ
//ณ    07    	CONTROLADORIA  ณ
//ณ    08    	QUALIDADE      ณ
//ณ    09    	TRANSPORTE     ณ
//ณ    10    	ENGENHARIA     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

           
Conout("###| CP01001W: "+cChvDanfe) 

IF !EMPTY(cChvDanfe)
	DBSELECTAREA("Z10")            

	Z10->(DBSETORDER(1))
	
	IF Z10->(DBSEEK(XFILIAL("Z10")+cChvDanfe,.F.))
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Grava tabela de Controle do WorkFlow ณ
		//ณ Abre Semaforo do  WorkFlow           ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cCodWF	:= U_qsCtrlWF("1")
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Envia e-mail ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		GeraWF(cCodWF, cDest, cChvDanfe, cLog)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Libera Semaforo do WF ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//		U_qsCodWF(cCodWF)
	ENDIF            
	
ENDIF		

RestArea(aAreaZ11)
RestArea(aAreaZ10)
RestArea(aArea)
Return(cCodWF)



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GeraWF   บAutor  ณ Augusto Ribeiro    บ Data ณ  22/08/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envia Workflow de status da solicitacao de compras         บฑฑ
ฑฑบ          ณ Este workflow nao recebe retorno.                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GeraWF(cCodWF,cDestinat, cChvDanfe, cLog)
Local lRet                                 
Local nTotal	:= 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Parametros  WorkFlow ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cCodProc 		:= "PRENOTA_AUTO"
Local cDescProc		:= "Alerta de recebimento Danfe.XML"  
Local cHTMLModelo	:= "\workflow\Templates\wfdanfe002.html" 

Local cDestinat		//:= ALLTRIM(UsrRetMail(TWF->C1_USER))
Local cSubject		:= "WORKFLOW: Alerta de recebimento Danfe.XML "
Local cFromName		:= "Workflow - NF Recebida"

Default cLog		:= ""

	cLog	:= replace(cLog, EOL, "<BR>")
      
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria Processo de Workflow ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oProcess	:= TWFProcess():New(cCodProc,cDescProc)
	oProcess:NewTask(cDescProc,cHTMLModelo)
	
	oHtml 		:= oProcess:oHtml
	
	oHtml:ValByName("Data",		DDATABASE)
	oHtml:ValByName("Hora",		ALLTRIM(TIME()) )		
	oHtml:ValByName("CodWF",	SM0->(M0_CODIGO+SM0->M0_CODFIL)+cCodWF )				
	
	oHtml:ValByName("ChvDanfe", 	Z10->Z10_CHVNFE)
	oHtml:ValByName("Nota",	  		Z10->Z10_NUMNFE)
	oHtml:ValByName("Serie", 		Z10->Z10_SERIE)
	oHtml:ValByName("Emissao", 		Z10->Z10_DTNFE)	
	
	oHtml:ValByName("Fornecedor",	Z10->Z10_RAZAO)
	oHtml:ValByName("CNPJ",			Z10->Z10_CNPJ) 
	
	oHtml:ValByName("Filial",		SM0->M0_CODFIL+"-"+SM0->M0_NOME)	
	
	DBSELECTAREA("Z11")
	Z11->(DBSETORDER(1)) 
	Z11->(DBSEEK(XFILIAL("Z11")+Z10->Z10_CHVNFE+Z10->Z10_TIPARQ,.F.))
	
	WHILE Z11->(!EOF()) .AND. Z11->Z11_CHVNFE == Z10->Z10_CHVNFE
				
		AAdd( oHtml:ValByName( "Item.CodPro" 	), Z11->Z11_CODPRO)
		AAdd( oHtml:ValByName( "Item.Produto"	), Z11->Z11_DESPRO)
		AAdd( oHtml:ValByName( "Item.CFOP"		), Z11->Z11_CFOP)		
		AAdd( oHtml:ValByName( "Item.UM" 		), Z11->Z11_UM)
		AAdd( oHtml:ValByName( "Item.Quant" 	), TRANSFORM(Z11->Z11_QUANT,PesqPict("SD1", "D1_QUANT")) )		
		AAdd( oHtml:ValByName( "Item.VlrUnit"	), TRANSFORM(Z11->Z11_VLRUNI,PesqPict("SD1", "D1_VUNIT")) )		
		AAdd( oHtml:ValByName( "Item.VlrTot" 	), TRANSFORM(Z11->Z11_VLRTOT,PesqPict("SD1", "D1_TOTAL")) )						
	            
		nTotal	+= Z11->Z11_VLRTOT
	      
		Z11->(DBSKIP())
	ENDDO	
	

	oHtml:ValByName("Total",		TRANSFORM(nTotal,PesqPict("SD1", "D1_TOTAL")) )

	oHtml:ValByName("Log",cLog)

	oProcess:ClientName(Subs(cUsuario,7,15))
	oProcess:cTo 		:= cDestinat
	oProcess:cBcc 		:= ""
	oProcess:cSubject 	:= cSubject
	oProcess:CFROMNAME 	:= cFromName
//	oProcess:CFROMADDR 	:= cMail
	oProcess:Start()
	oProcess:Free()	
	
Return(lRet)






/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ WFCancNFeบAutor  ณ Augusto Ribeiro    บ Data ณ  20/03/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envia Workflow de aviso de cancelamento da Danfe           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบPARMETROS ณ cChvDanfe                                                  บฑฑ
ฑฑบRETORNO   ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/     
User Function CP0101WC(cChvDanfe, cDest)
Local cQuery 	:= "" 
Local lEnviaWF
Local cCodWF	:= ""  
Local aArea		:= GetArea()
Local aAreaZ10	:= Z10->(GetArea())
                                        

IF !EMPTY(cChvDanfe) .and. !EMPTY(cDest)        
	
	IF Z10->(DBSEEK(XFILIAL("Z10")+cChvDanfe,.F.))
	
		IF Z10->Z10_STATUS == "2"	//| Importado
	
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Posiciona na Filial de retorno do Workflow ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			_cCodEmp 	:= SM0->M0_CODIGO
			_cCodFil	:= SM0->M0_CODFIL
			
			IF _cCodEmp+_cCodFil <> Z10->(Z10_CODEMP+Z10_CODFIL)
				CFILANT := Z10->Z10_CODFIL
				opensm0(_cCodEmp+CFILANT)
			ENDIF
				 	
			
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Grava tabela de Controle do WorkFlow ณ
				//ณ Abre Semaforo do  WorkFlow           ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//				cCodWF	:= U_qsCtrlWF("1")	    		
			
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Envia e-mail ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				GeraWFCan(cCodWF, cChvDanfe, cDest)
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Libera Semaforo do WF ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//				U_qsCodWF(cCodWF)   
			
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Restaura Filial ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			IF _cCodEmp+_cCodFil <> Z10->(Z10_CODEMP+Z10_CODFIL)
				CFILANT := _cCodFil
				opensm0(_cCodEmp+CFILANT)			 			
			ENDIF 
		ENDIF
	ENDIF				
ENDIF
		
RestArea(aAreaZ10)	
RestArea(aArea)
Return(cCodWF)



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GeraWF   บAutor  ณ Augusto Ribeiro    บ Data ณ  22/08/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envia Workflow de status da solicitacao de compras         บฑฑ
ฑฑบ          ณ Este workflow nao recebe retorno.                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GeraWFCan(cCodWF,cChvDanfe,cDestinat)
Local lRet                                 
Local nTotal	:= 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Parametros  WorkFlow ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cCodProc 		:= "DANFECANC"
Local cDescProc		:= "Danfe_Cancelada"  
Local cHTMLModelo	:= "\workflow\templates\wfdanfe003.html" 

Local cDestinat		//:= ALLTRIM(UsrRetMail(TWF->C1_USER))
Local cSubject		:= "QI - NFe integrada e cancelada - "
Local cFromName		:= "Workflow - NF Cancelada"
Local aAreaZ12		:= Z12->(GetArea()) 

DBSELECTAREA("Z10")
Z10->(DBSETORDER(1))	
                     
DBSELECTAREA("Z12")
Z12->(DBSETORDER(1))
	
IF Z12->(DBSEEK(XFILIAL("Z12")+cChvDanfe,.F.))
	
	DBSELECTAREA("SA2")
	SA2->(DBSETORDER(3))//| A2_FILIAL, A2_CGC
	SA2->(DBSEEK(XFILIAL("SA2")+Z10->Z10_CNPJ,.F.))
                                                          
	cSubject	:= SA2->(A2_COD+"-"+A2_LOJA+":"+ALLTRIM(A2_NOME))+" - NF: "+ALLTRIM(Z10->Z10_NUMNFE)+" SERIE: "+ALLTRIM(Z10->Z10_SERIE)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria Processo de Workflow ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oProcess	:= TWFProcess():New(cCodProc,cDescProc)
	oProcess:NewTask(cDescProc,cHTMLModelo)
	
	oHtml 		:= oProcess:oHtml
	
	oHtml:ValByName("Data",		DDATABASE)
	oHtml:ValByName("Hora",		ALLTRIM(TIME()) )		
	oHtml:ValByName("CodWF",	SM0->(M0_CODIGO+SM0->M0_CODFIL)+cCodWF )

	oHtml:ValByName("Fornecedor",	SA2->(A2_COD+"-"+A2_LOJA+":"+ALLTRIM(A2_NOME)) )
	oHtml:ValByName("Filial",		SM0->M0_CODFIL+"-"+SM0->M0_NOME)		
	oHtml:ValByName("Nota",	  		SF1->F1_DOC)
	oHtml:ValByName("Serie", 		SF1->F1_SERIE)
	oHtml:ValByName("DtEmissao", 	DTOC(Z10->Z10_DTNFE))
	oHtml:ValByName("DtImport", 	DTOC(Z10->Z10_DTIMP))
	oHtml:ValByName("ChvDanfe", 	Z10->Z10_CHVNFE)     
	oHtml:ValByName("Protocolo", 	alltrim(Z12->Z12_PROCAN))	
	oHtml:ValByName("DtCancel", 	DTOC(Z12->Z12_DTCAN))
		
	oProcess:ClientName(Subs(cUsuario,7,15))
	oProcess:cTo 		:= cDestinat
	oProcess:cBcc 		:= ""
	oProcess:cSubject 	:= cSubject
	oProcess:CFROMNAME 	:= cFromName
//	oProcess:CFROMADDR 	:= cMail
	oProcess:Start()
	oProcess:Free()	
	
ENDIF
	                
RestArea(aAreaZ12)		        
Return(lRet)



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GeraWF   บAutor  ณ Augusto Ribeiro    บ Data ณ  22/08/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envia Workflow de status da solicitacao de compras         บฑฑ
ฑฑบ          ณ Este workflow nao recebe retorno.                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GrvCanc(aDadosZ12)
Local aDadosZ12
Local lRet	:= .F.
Local nZ12CHVNFE, nZ12JUSCAN, nZ12DTCAN, nZ12HRCAN, nZ12PROCAN

Default aDadosZ12 := {}

IF LEN(aDadosZ12) > 0
	nZ12CHVNFE	:= aScan(aDadosZ12,{|x| ALLTRIM(x[1])=="Z12_CHVNFE"})
	nZ12JUSCAN	:= aScan(aDadosZ12,{|x| ALLTRIM(x[1])=="Z12_JUSCAN"})
	nZ12DTCAN	:= aScan(aDadosZ12,{|x| ALLTRIM(x[1])=="Z12_DTCAN"})
	nZ12HRCAN	:= aScan(aDadosZ12,{|x| ALLTRIM(x[1])=="Z12_HRCAN"})
	nZ12PROCAN	:= aScan(aDadosZ12,{|x| ALLTRIM(x[1])=="Z12_PROCAN"})
	       
	
	IF nZ12CHVNFE > 0 .AND.;
		nZ12JUSCAN > 0 .AND.;
		nZ12DTCAN > 0 .AND.;
		nZ12HRCAN > 0 .AND.;
		nZ12PROCAN > 0
		
		dbselectarea("Z12")
		Z12->(DBSETORDER(1))
		IF Z12->(!DBSEEK(XFILIAL("Z12")+aDadosZ12[nZ12CHVNFE, 2], .F.))

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Registra na tabela de Cancelamento ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			RegToMemory("Z12",.T.)
												
			M->Z12_CHVNFE	:= aDadosZ12[nZ12CHVNFE, 2]
			M->Z12_JUSCAN	:= aDadosZ12[nZ12JUSCAN, 2]
			M->Z12_DTCAN	:= aDadosZ12[nZ12DTCAN, 2]
			M->Z12_HRCAN	:= aDadosZ12[nZ12HRCAN, 2]
			M->Z12_PROCAN	:= aDadosZ12[nZ12PROCAN, 2]		
		
		 	RECLOCK("Z12",.T.)
				For nY := 1 To Z12->(FCOUNT())
					FieldPut(nY, M->&(Fieldname(nY)))
				Next nY	  
			Z12->(MSUNLOCK()) 
		ENDIF
		
		lRet	:= .T.
	ENDIF
ENDIF

Return(lRet)




/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CP0101DU บAutor  ณ Augusto Ribeiro	 บ Data ณ  28/04/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Apresenta interface com as duplicatas do XML               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function CP0101DU(cTipoArq, cChvNfe)

Default cTipoArq	:= Z10->Z10_TIPARQ
Default cChvNfe		:= Z10->Z10_CHVNFE

Private cTitulo	:= "Aprova็ใo Solicita็ใo de Compras"

DBSELECTAREA("Z13")
Z13->(DBSETORDER(1))

IF Z13->(DBSEEK(XFILIAL("Z13")+cChvNfe+cTipoArq))
	fDlgDup()  
else
	HELP(" ",1,"RECNO")
ENDIF

Return()



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CP0101FA บAutor  ณ Jonatas Oliveira   บ Data ณ  15/08/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Apresenta interface com as NF's Vinculadas ao Cte          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function CP0101FA(_cTipoArq, _cChvNfe)

Default _cTipoArq	:= Z10->Z10_TIPARQ
Default _cChvNfe		:= Z10->Z10_CHVNFE

Private _cTitulo	:= "Faturas Cte"

DBSELECTAREA("Z14")
Z14->(DBSETORDER(1))

IF Z14->(DBSEEK(XFILIAL("Z14")+_cChvNfe+_cTipoArq))
	fDlgFat()  
else
	HELP(" ",1,"RECNO")
ENDIF

Return()


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
Static Function fDlgDup()  
Local bOK		
Local bCanc		
Local aButtons	:= {}   
Local oFLabels := TFont():New("MS Sans Serif",,026,,.F.,,,,,.F.,.T.)
Local oFEspTec := TFont():New("MS Sans Serif",,016,,.F.,,,,,.F.,.T.)
                     
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis de posionamento dos campos ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private nSC1NUM
Private nSC1ITEM    
Private nPC1NUM
Private nPC1ITEM
Private nPC7NUM
Private nPC7ITEM
Private nPC7PRECO
                      
Private oEspTec, cEspTec
Private oDlgDup	:= NIL
Private aSize, aObjects, aInfo, aPosObj, aPosEnc
                
bOK		:= {|| ListSC("A",@oLbxSC,@aHeadSC, @aDadoSC), oLbxSC:Refresh() } //{|| oDlg:End()}
bCanc	:= {|| oDlgDup:End()} 	

aButtons	:= {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDimensionamento da Janela - Parte Superior ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aSize 		:= MsAdvSize()		
aObjects	 := {}
 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Caso chamada da funcao tenha sito feita pelo botao consultar log ณ
//ณ Redimenciona tela para melhor visualizacao                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAdd( aObjects, { 100, 100, .T., .T.} )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj 	:= MsObjSize( aInfo, aObjects, .T. )                                                                         

aPosObj[1,1]	+= 12

//aPosObj[1,3]	:= 
//aPosObj[1,4]	:= 


aPosEnc	:= {000,000,aPosObj[1,3]-aPosObj[1,1]-12,aPosObj[1,4]-aPosObj[1,2]-1}
		   



//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta Dialog ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DEFINE MSDIALOG oDlgDup TITLE cTitulo FROM 0,00 to (aSize[6]*0.60) ,(aSize[5]*0.60) OF oMainWnd PIXEL		

@ aPosObj[1,1]-12, aPosObj[1,2] SAY oLblSolicita PROMPT "Duplicatas do XML" SIZE 131, 014 OF oDlgDup FONT oFLabels COLORS 128, 16777215 PIXEL

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta List Solicitacao de Compras ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 
Private aHeadSC	:= {}       
Private aDadoSC	:= {}
Private oLbxSC	:= Nil            

ListSC("C",@oLbxSC,@aHeadSC, @aDadoSC)  

ACTIVATE MSDIALOG oDlgDup CENTERED ON INIT Eval({ || EnChoiceBar(oDlgDup,bOK,bCanc,.F.,aButtons) })

Return()   





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
Static Function fDlgFat()  
Local _bOK		
Local _bCanc		
Local _aButtons	:= {}   
Local _oFLabels := TFont():New("MS Sans Serif",,026,,.F.,,,,,.F.,.T.)
Local _oFEspTec := TFont():New("MS Sans Serif",,016,,.F.,,,,,.F.,.T.)
                     
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis de posionamento dos campos ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private _nSC1NUM
Private _nSC1ITEM    
Private _nPC1NUM
Private _nPC1ITEM
Private _nPC7NUM
Private _nPC7ITEM
Private _nPC7PRECO
                      
Private _oEspTec, _cEspTec
Private _oDlgZ14	:= NIL
Private _aSize, _aObjects, _aInfo, _aPosObj, _aPosEnc
                
_bOK		:= {|| ListSCZ14("A",@oLbxSC,@aHeadSC, @aDadoSC), oLbxSC:Refresh() } //{|| oDlg:End()}
_bCanc	:= {|| _oDlgZ14:End()} 	

_aButtons	:= {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDimensionamento da Janela - Parte Superior ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_aSize 		:= MsAdvSize()		
_aObjects	 := {}
 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Caso chamada da funcao tenha sito feita pelo botao consultar log ณ
//ณ Redimenciona tela para melhor visualizacao                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAdd( _aObjects, { 100, 100, .T., .T.} )

_aInfo := { _aSize[ 1 ], _aSize[ 2 ], _aSize[ 3 ], _aSize[ 4 ], 3, 3 }
_aPosObj 	:= MsObjSize( _aInfo, _aObjects, .T. )                                                                         

_aPosObj[1,1]	+= 12

//aPosObj[1,3]	:= 
//aPosObj[1,4]	:= 


_aPosEnc	:= {000,000,_aPosObj[1,3]-_aPosObj[1,1]-12,_aPosObj[1,4]-_aPosObj[1,2]-1}
		   



//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta Dialog ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DEFINE MSDIALOG _oDlgZ14 TITLE _cTitulo FROM 0,00 to (_aSize[6]*0.60) ,(_aSize[5]*0.60) OF oMainWnd PIXEL		

@ _aPosObj[1,1]-12, _aPosObj[1,2] SAY oLblSolicita PROMPT "Faturas Cte" SIZE 131, 014 OF _oDlgZ14 FONT _oFLabels COLORS 128, 16777215 PIXEL

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta List Solicitacao de Compras ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 
Private aHeadSC	:= {}       
Private aDadoSC	:= {}
Private oLbxSC	:= Nil            

ListSCZ14("C",@oLbxSC,@aHeadSC, @aDadoSC)  

ACTIVATE MSDIALOG _oDlgZ14 CENTERED ON INIT Eval({ || EnChoiceBar(_oDlgZ14,_bOK,_bCanc,.F.,_aButtons) })

Return()   






/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ListSC   บAutor  ณ Augusto Ribeiro	 บ Data ณ  10/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  List Solicitacao de Compras                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function ListSC(cOpcList,oLbxSC,aHeader, aDados)
Local lRet		:= .T.
Local cQuery	:= "" 
Local aCpoHeader, aLinha
Local cBCodLin	:= ""
     
aCpoHeader	:= {} 
aHeader		:= {} 
aDados		:= {}
                      


//ฺฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ   QUERY   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤู
cQuery	:= " SELECT Z13_ITEM, Z13_DUPLIC, Z13_DTVENC, Z13_VALOR "
cQuery	+= " FROM "+RetSqlName("Z13")
cQuery	+= " WHERE Z13_FILIAL = '"+Z13->Z13_FILIAL+"' "
cQuery	+= " AND Z13_CHVNFE = '"+Z13->Z13_CHVNFE+"' "
cQuery	+= " AND Z13_TIPARQ = '"+Z13->Z13_TIPARQ+"' "
cQuery	+= " AND D_E_L_E_T_ = '' "

If Select("QRY") > 0
	QRY->(DbCloseArea())
EndIf
          
cQuery	:= ChangeQuery(cQuery)
                   
MSGRUN("Aguarde....","SQL" ,		{|| dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),'QRY') } )					

TCSetField("QRY","Z13_DTVENC","D",08,00) 


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta aHeader ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 
For nY := 1 To QRY->(FCOUNT())      
	cTitCol	:= ALLTRIM(RetTitle(FieldName(nY)))
	IF EMPTY(cTitCol)        
	   	aadd(aHeader,FieldName(nY))	
	ELSE
	   	aadd(aHeader,cTitCol)
	ENDIF
	aadd(aCpoHeader,FieldName(nY))
Next nY	


IF QRY->(!EOF()) 
		
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta aDados ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	WHILE QRY->(!EOF())

		aLinha	:= {}     
		For nY := 1 To QRY->(FCOUNT())      
                                      
			cNomeCampo	:= alltrim(QRY->(FieldName(nY)))
			
			IF VALTYPE(QRY->&(cNomeCampo)) == "C"     
			
				aadd(aLinha, ALLTRIM(QRY->&(cNomeCampo)) )
			ELSE                                              				
				aadd(aLinha, QRY->&(cNomeCampo) )
			ENDIF
		Next nY	 
		
	 	AADD(aDados, aLinha)
	 	
		QRY->(DBSKIP())
	ENDDO  
ELSE
	aLinha	:= {}
	AADD(aLinha, .F.)
	For nY := 1 To QRY->(FCOUNT())
		aadd(aLinha, CRIAVAR(FieldName(nY),.F.) )    		
	Next nY	 

 	AADD(aDados, aLinha)
ENDIF                     
	     
	
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ cOpcList | C = Cria, A = Atualiza ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
IF cOpcList == "C"

	@ aPosObj[1,1],aPosObj[1,2] LISTBOX oLbxSC FIELDS HEADER ;
	   " ", "Campos" ;                                                                                                                                
	   SIZE (aPosObj[1,4]*0.60), (aPosObj[1,3]*0.60)-20 OF oDlgDup PIXEL
ENDIF

oLbxSC:aheaders := aHeader
oLbxSC:SetArray( aDados )  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria string com Bloco de Codigo ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cBCodLin	:= ""
For nI := 1 To LEN(aHeader)
	IF nI > 1
		cBCodLin	+=", "
	endif
   cBCodLin	+= "aDados[oLbxSC:nAt,"+alltrim(str(nI))+"]"
Next nI	

cBCodLin	:= "oLbxSC:bLine := {|| {"+cBCodLin+"}}"
&(cBCodLin)

Return(lRet)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ListSC   บAutor  ณ Augusto Ribeiro	 บ Data ณ  10/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Lista as Nf's vinculadas ao Cte                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function ListSCZ14(cOpcList,oLbxSC,aHeader, aDados)
Local lRet		:= .T.
Local cQuery	:= "" 
Local aCpoHeader, aLinha
Local cBCodLin	:= ""
     
aCpoHeader	:= {} 
aHeader		:= {} 
aDados		:= {}
                      
//ฺฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ   QUERY   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤู
cQuery	:= " SELECT Z14_ITEM, Z14_FATURA, Z14_CHVNFE "
cQuery	+= " FROM "+RetSqlName("Z14")
cQuery	+= " WHERE Z14_FILIAL = '"+Z14->Z14_FILIAL+"' "
cQuery	+= " AND Z14_CHVCTE = '"+Z14->Z14_CHVCTE+"' "
cQuery	+= " AND Z14_TIPARQ = '"+Z14->Z14_TIPARQ+"' "
cQuery	+= " AND D_E_L_E_T_ = '' "

If Select("QRY") > 0
	QRY->(DbCloseArea())
EndIf
          
cQuery	:= ChangeQuery(cQuery)
                   
MSGRUN("Aguarde....","SQL" ,		{|| dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),'QRY') } )					


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta aHeader ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 
For nY := 1 To QRY->(FCOUNT())      
	cTitCol	:= ALLTRIM(RetTitle(FieldName(nY)))
	IF EMPTY(cTitCol)        
	   	aadd(aHeader,FieldName(nY))	
	ELSE
	   	aadd(aHeader,cTitCol)
	ENDIF
	aadd(aCpoHeader,FieldName(nY))
Next nY	


IF QRY->(!EOF()) 
		
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta aDados ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	WHILE QRY->(!EOF())

		aLinha	:= {}     
		For nY := 1 To QRY->(FCOUNT())      
                                      
			cNomeCampo	:= alltrim(QRY->(FieldName(nY)))
			
			IF VALTYPE(QRY->&(cNomeCampo)) == "C"     
			
				aadd(aLinha, ALLTRIM(QRY->&(cNomeCampo)) )
			ELSE                                              				
				aadd(aLinha, QRY->&(cNomeCampo) )
			ENDIF
		Next nY	 
		
	 	AADD(aDados, aLinha)
	 	
		QRY->(DBSKIP())
	ENDDO  
ELSE
	aLinha	:= {}
	AADD(aLinha, .F.)
	For nY := 1 To QRY->(FCOUNT())
		aadd(aLinha, CRIAVAR(FieldName(nY),.F.) )    		
	Next nY	 

 	AADD(aDados, aLinha)
ENDIF                     
	     
	
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ cOpcList | C = Cria, A = Atualiza ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
IF cOpcList == "C"

	@ _aPosObj[1,1],_aPosObj[1,2] LISTBOX oLbxSC FIELDS HEADER ;
	   " ", "Campos" ;                                                                                                                                
	   SIZE (_aPosObj[1,4]*0.60), (_aPosObj[1,3]*0.60)-20 OF _oDlgZ14 PIXEL
ENDIF

oLbxSC:aheaders := aHeader
oLbxSC:SetArray( aDados )  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria string com Bloco de Codigo ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cBCodLin	:= ""
For nI := 1 To LEN(aHeader)
	IF nI > 1
		cBCodLin	+=", "
	endif
   cBCodLin	+= "aDados[oLbxSC:nAt,"+alltrim(str(nI))+"]"
Next nI	

cBCodLin	:= "oLbxSC:bLine := {|| {"+cBCodLin+"}}"
&(cBCodLin)

Return(lRet)
       

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CP01001N บAutor  ณ Augusto Ribeiro	  บ Data ณ  05/07/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera Nota Fiscal / Documento de Entrada                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function CP01001N(lAuto)
Local aRetImp	:= {.F.,""}
Local lAuto  
Local cLogReg	:= ""     
Local cQryPre
Local nRec	:= 0	
           
Default lAuto	:= .F.


	
	IF Z10->Z10_VALIDA == "2" 
		
		lGeraNF	:= .T.
	ELSEIF Z10->Z10_STATUS == "2" .AND.  Z10->Z10_VALIDA <> "2"
		
		Reclock("Z10",.F.)
			Z10->Z10_VALIDA := "2"                       
		Z10->(MSUNLOCK())		
		
		lGeraNF	:= .T.	
	ELSEIF Z10->Z10_VALIDA == "3"

		cLogReg	+= "Danfe invแlida."
	ELSE 
		cLogReg += " Por favor, verifique a valide a Danfe antes de executar esta fun็ใo."
	ENDIF

	
	IF (Z10->Z10_VALIDA == "2" .AND. Z10->Z10_STATUS == "2") .OR. Z10->Z10_STATUS == "2"

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Gera Pre-Nota ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                               
		IF Z10->Z10_TIPARQ == "E" .OR. Z10->Z10_TIPARQ == "C"//|Tipo Arquivo
		          
			cQryPre	:= " SELECT R_E_C_N_O_ as SF1_RECNO "
			cQryPre	+= " FROM "+RetSqlName("SF1")
			cQryPre	+= " WHERE F1_CHVNFE = '"+Z10->Z10_CHVNFE+"' "
			cQryPre	+= " AND D_E_L_E_T_ = '' "   
			
			cQryPre	:= ChangeQuery(cQryPre)
			
			TcQuery cQryPre New Alias "TSF1"	                  
			
			IF TSF1->(!EOF())
				nRec	:= TSF1->SF1_RECNO
			ENDIF	
			
			TSF1->(DBCLOSEAREA())      				
		
			IF nRec > 0
				DBSELECTAREA("SF1")
				SF1->(DBGOTO(nRec))
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Classifica Nota Fiscal automaticamente ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				aRetImp	:= U_CP0108E(SF1->F1_DOC, SF1->F1_SERIE, SF1->F1_FORNECE, SF1->F1_LOJA)

				IF aRetImp[1]
					cLogReg +=  "Nota Gerada com Sucesso"+EOL
				ELSE
					cLogReg +=  "Falha na Gera็ใo do Documento de entrada: "+EOL+aRetImp[2]+EOL
				ENDIF
			ELSE
				cLogReg +=  "Pre-Nota nใo encontrada."+EOL
			ENDIF
			
		ELSEIF Z10->Z10_TIPARQ == "S"                   

			cQryPre	:= " SELECT R_E_C_N_O_ as SC5_RECNO "
			cQryPre	+= " FROM "+RetSqlName("SC5")
			cQryPre	+= " WHERE C5_XCHVNFE = '"+Z10->Z10_CHVNFE+"' "
			cQryPre	+= " AND D_E_L_E_T_ = '' "

			cQryPre	:= ChangeQuery(cQryPre)
			
			TcQuery cQryPre New Alias "TSC5"
			
			IF TSC5->(!EOF())
				nRec	:= TSC5->SC5_RECNO
			ENDIF	
			
			TSC5->(DBCLOSEAREA())      				
		
			IF nRec > 0  
				DBSELECTAREA("SC5")
				SC5->(DBGOTO(nRec))			

				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Classifica Nota Fiscal automaticamente ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				IF EMPTY(SC5->C5_NOTA)
					aRetImp	:= U_CP0108S(Z10->Z10_NUMPV,Z10->Z10_CHVNFE)
				ELSE
					Reclock("Z10",.F.)
						Z10->Z10_STATUS := "5"                       
					Z10->(MSUNLOCK())			          											
				ENDIF 	
				IF aRetImp[1]
					cLogReg +=  "Nota Gerada com Sucesso"+EOL
				ELSE
					cLogReg += "Falha na Gera็ใo da Nota Fiscal  de Saํda: "+EOL+aRetImp[2]+EOL
				ENDIF
			ELSE
				cLogReg +=  "Pedido de Venda nใo encontrada."+EOL					
			ENDIF				
		ENDIF
	ELSE
		cLogReg += "Por favor, verifique o status do registro."
	ENDIF	         
        

	aRetImp[2]	:= cLogReg
	
	IF !(lAuto) .AND. aRetImp[1]
	//	MSGBOX(aRetImp[2], "Sucesso", "INFO")
		
	ELSEIF !(lAuto) .AND. !(aRetImp[1])		
		Aviso("Falha ao Gerar a Pre-Nota", aRetImp[2],{"Voltar"},3)		
	ENDIF
	
Return(aRetImp)                                                                           


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CP01001T บAutor  ณ Jonatas Oliveira   บ Data ณ  26/07/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera Nota Fiscal / Documento de Entrada em Lote            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function CP01001T(lAuto)   
Local cTitulo 		:= "NF em Lote"        
Local _aBotoes		:= {}               
Local cCadastro		:= OemToAnsi("Lote NF")
Local _aSay			:= {}
Local cPerg			:= "CP010T" //| Parametros para usuแrio
Local aRetImp2		:= {.F.,""}
Local cLogReg		:= ""
Local cQryZ10   	:= ""
Local nRec			:= 0  
Local _lProcess 	:= .F.
Local _lPerg 		:= .F.
Local lAuto
Local cQryPre2	

Private _cFileLog	:= ""
Private _cLogPath	:= ""
Private _Handle		:= ""  

Default lAuto		:= .F.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Parametros do Usuario ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
AjustSX1(cPerg)

_aSay	:= {cTitulo,;
"  ",;
" Esta rotina gera NOTA FISCAL dos arquivos com STATUS => (Pre-Nota/Ped. Venda Gerado) conforme",;
" Parametros informados.                                  ",;
" ",;
" ",;
"                                                                                                                                       v1.0"}
aAdd(_aBotoes, { 5,.T.,{|| _lPerg := PERGUNTE(cPerg,.T.)}})
aAdd(_aBotoes, { 1,.T.,{|| _lProcess := .T., FechaBatch() }} )
aAdd(_aBotoes, { 2,.T.,{|| _lProcess := .F., FechaBatch()  }} )

FormBatch( cTitulo, _aSay, _aBotoes ,,240,510)


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณForca o preenchimento das perguntas caso clique em Confirmarณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
IF !_lPerg .AND.  _lProcess 
	_lPerg := PERGUNTE(cPerg,.T.)

ENDIF 


IF _lProcess  .AND. _lPerg             
		             
	cQryZ10	:= " SELECT R_E_C_N_O_ as Z10_RECNO "
	cQryZ10	+= " FROM "+RetSqlName("Z10")
	cQryZ10	+= " WHERE Z10_DTIMP BETWEEN '"+DToS(MV_PAR01)+"' AND '"+DToS(MV_PAR02)+"' " 
	cQryZ10	+= " AND Z10_NUMNFE BETWEEN '"+MV_PAR03+"' AND  '"+MV_PAR04+"' ""
	If !Empty(MV_PAR05)
		cQryZ10	+= " 	AND Z10_CNPJ = '"+MV_PAR05+"'"
	Endif
	cQryZ10	+= " AND Z10_VALIDA = '2' "
	cQryZ10	+= " AND Z10_STATUS = '2' "
	cQryZ10	+= " AND D_E_L_E_T_ <> '*' "
	
	cQryZ10	:= ChangeQuery(cQryZ10)
	
	
	If Select("QRYZ10") > 0
		QRYZ10->(DbCloseArea())
	EndIf
	
	DBUseArea(.T.,"TOPCONN", TCGenQry(,,cQryZ10),"QRYZ10", .F., .T.)
	nCount	:= 0
	
	QRYZ10->(DBGoTop())	
	QRYZ10->( dbEval( {|| nCount++ } ) )	
	QRYZ10->(DBGoTop())
	
	
	DBSELECTAREA("Z10")
	Z10->(DBSETORDER(1))
	Z10->(DBGOTOP())
	
	fGrvLog(1,"Iniciando grava็ใo de Log Geracao de NF em Lote. "+TIME()+". "+ DToC(ddatabase)  )
	
	ProcRegua(nCount)	
	
	IF 	QRYZ10->(EOF())   
		fGrvLog(2,"Por favor, verifique os parametros informados. Nao existem notas a serem geradas. "+TIME()+". "+ DToC(ddatabase))
	
	ENDIF 
	
	WHILE QRYZ10->(!EOF())   
		Z10->(DBGOTO(QRYZ10->Z10_RECNO))
	
		IncProc("Gerando Nota Fiscal | "+alltrim(TRANSFORM(nCount,"@e 999,999,999"))+" Registros")
	
			
		cQryPre2 	:= ""
		cLogReg 	:= ""
		
		IF Z10->Z10_VALIDA == "2"
			
			lGeraNF	:= .T.
			
		ELSEIF Z10->Z10_VALIDA == "3"
			fGrvLog(2,"Danfe invแlida. "+Z10->Z10_NUMNFE+". "+TIME()+". "+ DToC(ddatabase))
		ELSE
			fGrvLog(2,"Por favor, verifique a valide a Danfe antes de executar esta fun็ใo. "+Z10->Z10_NUMNFE+". "+TIME()+". "+ DToC(ddatabase))
		ENDIF
		
		
		IF Z10->Z10_VALIDA == "2" .AND. Z10->Z10_STATUS == "2"
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Gera Pre-Nota ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			IF Z10->Z10_TIPARQ == "E" .OR. Z10->Z10_TIPARQ == "C"//|Tipo Arquivo
				
				cQryPre2	:= " SELECT R_E_C_N_O_ as SF1_RECNO "
				cQryPre2	+= " FROM "+RetSqlName("SF1")
				cQryPre2	+= " WHERE F1_CHVNFE = '"+Z10->Z10_CHVNFE+"' "
				cQryPre2	+= " AND D_E_L_E_T_ = '' "
				
				cQryPre2	:= ChangeQuery(cQryPre2)
				
				TcQuery cQryPre2 New Alias "TSF2"
				
				IF TSF2->(!EOF())
					nRec	:= TSF2->SF1_RECNO
				ENDIF
				
				TSF2->(DBCLOSEAREA())
				
				IF nRec > 0
					DBSELECTAREA("SF1")
					SF1->(DBGOTO(nRec))
					
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณ Classifica Nota Fiscal automaticamente ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					aRetImp2	:= U_CP0108E(SF1->F1_DOC, SF1->F1_SERIE, SF1->F1_FORNECE, SF1->F1_LOJA)
					
					IF aRetImp2[1]
						fGrvLog(2,"Nota Gerada com Sucesso. "+Z10->Z10_NUMNFE+". "+TIME()+". "+ DToC(ddatabase))
					ELSE
						fGrvLog(2,"Falha na Gera็ใo do Documento de entrada: "+Z10->Z10_NUMNFE+". "+TIME()+". "+ DToC(ddatabase))
					ENDIF
				ELSE
					fGrvLog(2,"Pre-Nota nใo encontrada. "+Z10->Z10_NUMNFE+". "+TIME()+". "+ DToC(ddatabase))
				ENDIF
				
			ELSEIF Z10->Z10_TIPARQ == "S"
				
				cQryPre2	:= " SELECT R_E_C_N_O_ as SC5_RECNO "
				cQryPre2	+= " FROM "+RetSqlName("SC5")
				cQryPre2	+= " WHERE C5_XCHVNFE = '"+Z10->Z10_CHVNFE+"' "
				cQryPre2	+= " AND D_E_L_E_T_ = '' "
				
				cQryPre2	:= ChangeQuery(cQryPre2)
				
				TcQuery cQryPre2 New Alias "TSC5"
				
				IF TSC5->(!EOF())
					nRec	:= TSC5->SC5_RECNO
				ENDIF
				
				TSC5->(DBCLOSEAREA())
				
				IF nRec > 0
					DBSELECTAREA("SC5")
					SC5->(DBGOTO(nRec))
					
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณ Classifica Nota Fiscal automaticamente ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					aRetImp2	:= U_CP0108S(,Z10->Z10_CHVNFE)
					IF aRetImp2[1]
						fGrvLog(2,"Nota Gerada com Sucesso. "+Z10->Z10_NUMNFE+". "+TIME()+". "+ DToC(ddatabase))
					ELSE
						fGrvLog(2,"Falha na Gera็ใo da Nota Fiscal  de Saํda: "+Z10->Z10_NUMNFE+". "+TIME()+". "+ DToC(ddatabase))
					ENDIF
				ELSE
					fGrvLog(2,"Pedido de Venda nใo encontrado. "+Z10->Z10_NUMNFE+". "+TIME()+". "+ DToC(ddatabase))
				ENDIF
			ENDIF
		ELSE
			fGrvLog(2,"Por favor, verifique o status do registro."+Z10->Z10_NUMNFE+". "+TIME()+". "+ DToC(ddatabase))
		ENDIF
			
		QRYZ10->(DBSKIP())
	ENDDO
	fGrvLog(3,"Fim da Grava็ใo . "+TIME()+". "+ DToC(ddatabase))
ENDIF	

Return()    

       

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CP0101CT บAutor  ณ Jonatas Oliveira   บ Data ณ  03/08/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera a Pre-Nota em Lote conforme parametros informados     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function CP0101CT(lAuto)
Local cTitulo 		:= "Pre-Nota/PV em Lote "
Local _aBotoes		:= {}
Local cCadastro		:= OemToAnsi("Lote Pre-Nota/PV")
Local _aSay			:= {}
Local cPerg			:= "CP010T" //| Parametros para usuแrio
Local aRetImp2		:= {.F.,""}
Local cLogReg		:= ""
Local cQryZ102   	:= ""
Local nRec			:= 0
Local _lProcess 	:= .F.
Local _lPerg 		:= .F.
Local lAuto
Local cQryPre2

Local cCFBYPASS		:= ALLTRIM(U_CP01005G("11", "CFPRENOTA"))
Local aCFBYPASS
Local _lClassAut	:= .F. 


Private _cFileLog	:= ""
Private _cLogPath	:= ""
Private _Handle		:= ""

Default lAuto		:= .F.


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Parametros do Usuario ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
AjustSX1(cPerg)

_aSay	:= {cTitulo,;
"  ",;
" Esta rotina gera (Pr้-Nota/PV) dos arquivos com Status (VALIDADO) conforme",;
" Parametros informados.                                  ",;
" ",;
" ",;
"                                                                                                                                       v1.0"}
aAdd(_aBotoes, { 5,.T.,{|| _lPerg := PERGUNTE(cPerg,.T.)}})
aAdd(_aBotoes, { 1,.T.,{|| _lProcess := .T., FechaBatch() }} )
aAdd(_aBotoes, { 2,.T.,{|| _lProcess := .F., FechaBatch()  }} )

FormBatch( cTitulo, _aSay, _aBotoes ,,240,510)


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณForca o preenchimento das perguntas caso clique em Confirmarณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
IF !_lPerg .AND.  _lProcess
	_lPerg := PERGUNTE(cPerg,.T.)
	
ENDIF


IF _lProcess  .AND. _lPerg
	
	
	cQryZ102	:= " SELECT R_E_C_N_O_ as Z10_RECNO "
	cQryZ102	+= " FROM "+RetSqlName("Z10")
	cQryZ102	+= " WHERE Z10_DTIMP BETWEEN '"+DToS(MV_PAR01)+"' AND '"+DToS(MV_PAR02)+"' "
	cQryZ102	+= " 	AND Z10_NUMNFE BETWEEN '"+MV_PAR03+"' AND  '"+MV_PAR04+"' ""
	If !Empty(MV_PAR05)
		cQryZ102	+= " 	AND Z10_CNPJ = '"+MV_PAR05+"'"
	Endif
	cQryZ102	+= " 	AND Z10_STATUS = '1' "
	//cQryZ102	+= " 	AND Z10_VALIDA = '2' "
	cQryZ102	+= " 	AND Z10_ARQCAN = '' "
	cQryZ102	+= " 	AND D_E_L_E_T_ <> '*' "
	
	
	cQryZ102	:= ChangeQuery(cQryZ102)
	
	
	If Select("QRYZ102") > 0
		QRYZ102->(DbCloseArea())
	EndIf
	
	DBUseArea(.T.,"TOPCONN", TCGenQry(,,cQryZ102),"QRYZ102", .F., .T.)
	nCount	:= 0
	
	QRYZ102->(DBGoTop())
	QRYZ102->( dbEval( {|| nCount++ } ) )
	QRYZ102->(DBGoTop())
	
	DBSELECTAREA("Z10")
	Z10->(DBSETORDER(1))
	Z10->(DBGOTOP())
	
	fGrvLog(1,"Iniciando grava็ใo de Log Geracao de PV e Pr้-Nota em Lote. "+TIME()+". "+ DToC(ddatabase)  )
	
	ProcRegua(nCount)
	
	IF 	QRYZ102->(EOF())
		fGrvLog(2,"Por favor, verifique os parametros informados. Nao existem notas a serem geradas. "+TIME()+". "+ DToC(ddatabase))
		
	ENDIF
	
	WHILE QRYZ102->(!EOF())
		Z10->(DBGOTO(QRYZ102->Z10_RECNO))
 		
		IncProc("Gerando PV / Pr้-nota   "+alltrim(TRANSFORM(nCount,"@e 999,999,999"))+" Registros")   

		
		cQryPre2 	:= ""
		cLogReg 	:= ""
		lGeraNF 	:= .F. 
		aRetImp2	:= {.F.,""}
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Valida Novamente NF-e antes de gerar a Pr้-Nota ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		U_CP01001V(1)
		
		
		IF Z10->Z10_VALIDA == "2"
			
			lGeraNF	:= .T.
			
		ELSEIF Z10->Z10_VALIDA == "3"
			cLogReg	+= "Danfe invแlida."
			fGrvLog(2,cLogReg+"Danfe "+Z10->Z10_NUMNFE+". "+TIME()+". "+ DToC(ddatabase))
			
		ELSE
			cLogReg += " Por favor, verifique a valide a Danfe antes de executar esta fun็ใo."
			fGrvLog(2,cLogReg+"Danfe "+Z10->Z10_NUMNFE+". "+TIME()+". "+ DToC(ddatabase))
		ENDIF
		
		
		IF lGeraNF
			
			IF Z10->Z10_STATUS == "1"	//nใo importado
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Gera Pre-Nota ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				//IF Z10->Z10_TIPNFE == "D" .and. lRetPad
				//substituํda linha acima pelo bloco abaixo [Mauro Nagata, Compila, 20200213]
				
				IF Z10->Z10_TIPNFE == "D"
				 	If lRetPad		//retorno de devolu็ใo por padrใo
						U_A103Devol()	//fun็ใo padrใo retornar do documento de Entrada						            
						aRetImp2	:= { .T.,""}
					Else
						aRetImp2	:= U_CP0102E(lAuto, Z10->Z10_CHVNFE,Z10->Z10_TIPARQ)
						/*
						aNFDev := {}
						DbSelectArea("Z11")
						DbSetOrder(1)
						DbSeek(xFilial("Z11")+Z10->Z10_CHVNFE)
						Do While !Eof() .And. Z10->Z10_CHVNFE = Z11->Z11_CHVNFE	
							aAdd(aNFSaixDev, Z11->Z11_NFORIG, Z11->Z11_SERORI, Z11->Z11_NFITOR, Z11->Z11_ITEM, Z11->Z11_CODPRO ) 
							DbSkip()
						EndDo*/
					EndIf
				//fim bloco [Mauro Nagata, Compila, 20200213]
				
				ELSEIF Z10->Z10_TIPARQ == "E" .OR. Z10->Z10_TIPARQ == "C"//|Tipo Arquivo
					aRetImp2	:= U_CP0102E(lAuto, Z10->Z10_CHVNFE,Z10->Z10_TIPARQ)
					
					IF aRetImp2[1]
						cLogReg +=  "Pre-Nota gerada com sucesso: "+EOL+aRetImp2[2]+EOL
						fGrvLog(2,cLogReg+"Danfe "+Z10->Z10_NUMNFE+". "+TIME()+". "+ DToC(ddatabase))
						
						DBSELECTAREA("SF1")
						SF1->(DBGOTO(aRetImp2[3]))
						
						
						If !EMPTY(cCFBYPASS) 
							aCFBYPASS := U_cpC2A(cCFBYPASS, "/")
						EndIf 
						
						aAreaZ11		:= Z11->(GetArea())
						Z11->(DBGOTOP())
						
						IF Z11->(DBSEEK(Z10->( Z10_FILIAL + Z10_CHVNFE )))
							IF ASCAN(aCFBYPASS, RIGHT(ALLTRIM(Z11->Z11_CFOP),3) ) > 0 
								_lClassAut := .T.
							ENDIF 
						ENDIF 
						
						RestArea( aAreaZ11 )
						
						//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
						//ณ Classifica Nota Fiscal automaticamente ณ
						//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
						IF (_lDocEnt .OR. _lClassAut) //U_CP01005G("11", "GERADOCAUT")
							aRetImp2	:= U_CP0108E(SF1->F1_DOC, SF1->F1_SERIE, SF1->F1_FORNECE, SF1->F1_LOJA)
							
							IF aRetImp2[1]
								cLogReg +=  "Nota Gerada com Sucesso"+EOL
								fGrvLog(2,cLogReg+"Danfe "+Z10->Z10_NUMNFE+". "+TIME()+". "+ DToC(ddatabase))
							ELSE
								cLogReg +=  "Falha na Gera็ใo dO Documento de entrada: "+EOL+aRetImp2[2]+EOL
								fGrvLog(2,cLogReg+"Danfe "+Z10->Z10_NUMNFE+". "+TIME()+". "+ DToC(ddatabase))
							ENDIF
						ENDIF
					ELSE
						cLogReg +=  "Falha na Gera็ใo da Pr้ Nota: "+EOL+aRetImp2[2]+EOL
						fGrvLog(2,cLogReg+"Danfe "+Z10->Z10_NUMNFE+". "+TIME()+". "+ DToC(ddatabase))
					ENDIF
					
				ELSEIF Z10->Z10_TIPARQ == "S"
					aRetImp2	:= U_CP0102S(lAuto, Z10->Z10_CHVNFE)
					cLogReg		+= 	aRetImp2[2]		
					
					IF aRetImp2[1]
						cLogReg +=  "Pedido de Venda gerado com sucesso: "+EOL+aRetImp2[2]+EOL
						fGrvLog(2,cLogReg+"Danfe "+Z10->Z10_NUMNFE+". "+TIME()+". "+ DToC(ddatabase))
						
						//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
						//ณ Classifica Nota Fiscal automaticamente ณ
						//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
						IF _lDocSai //U_CP01005G("12", "GERADOCAUT")
							aRetImp2	:= U_CP0108S(,Z10->Z10_CHVNFE)
							IF aRetImp2[1]
								cLogReg +=  "Nota Gerada com Sucesso"+EOL
								fGrvLog(2,cLogReg+"Danfe "+Z10->Z10_NUMNFE+". "+TIME()+". "+ DToC(ddatabase))
							ELSE
								cLogReg += "Falha na Gera็ใo da Nota Fiscal  de Saํda: "+EOL+aRetImp2[2]+EOL
								fGrvLog(2,cLogReg+"Danfe "+Z10->Z10_NUMNFE+". "+TIME()+". "+ DToC(ddatabase))
							ENDIF
						ENDIF
					ENDIF
				ENDIF
				
				
				IF aRetImp2[1]
					//				MSGBOX("Pr้-Nota gerada com sucesso!", "Pr้-Nota Gerada", "INFO")
					//				aRetImp2[2]	:= "Pr้-Nota gerada com sucesso"+EOL+aRetImp2[2]
				ELSE
					//				aRetImp2[2]	:= "Falha na Gera็ใo da Pr้ Nota: "+EOL+aRetImp2[2]
				ENDIF
			ELSE
				cLogReg += "Verifique o Status da Danfe"
				fGrvLog(2,cLogReg+"Danfe "+Z10->Z10_NUMNFE+". "+TIME()+". "+ DToC(ddatabase))
			ENDIF
			
		ELSE
			cLogReg += "Por favor, verifique a valide a Danfe antes de executar esta fun็ใo."
			fGrvLog(2,cLogReg+"Danfe "+Z10->Z10_NUMNFE+". "+TIME()+". "+ DToC(ddatabase)+CRLF)
		ENDIF
		
		
		aRetImp2[2]	:= cLogReg
		
		IF !(lAuto) .AND. aRetImp2[1]
			//	MSGBOX(aRetImp2[2], "Sucesso", "INFO")
			
		ELSEIF !(lAuto) .AND. !(aRetImp2[1])
//			Aviso("Falha a Gerar Pre-Nota", aRetImp2[2],{"Voltar"},3)
			fGrvLog(2,cLogReg+"Danfe "+Z10->Z10_NUMNFE+". "+TIME()+". "+ DToC(ddatabase))
		ENDIF
		
		QRYZ102->(DBSKIP())
	ENDDO
	
	fGrvLog(3,"Fim da Grava็ใo . "+TIME()+". "+ DToC(ddatabase))
	
ENDIF
Return(aRetImp2)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Realiza a Cria็ใo, Gravacao, Apresentacao do Log de acordo com o Pametro passado ณ
//ณ                                                                                  ณ
//ณ PARAMETRO	DESCRICAO                                                            ณ
//ณ _nOpc		Opcao:  1= Cria Arquivo de Log, 2= Grava Log, 3 = Apresenta Log      ณ
//ณ _cTxtLog	Log a ser gravado                                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Static Function fGrvLog(_nOpc, _cTxtLog)
Local _lRet	:= Nil
Local _nOpc, _cTxtLog
Local _EOL	:= chr(13)+chr(10)

Default _nOpc		:= 0
Default _cTxtLog 	:= ""
_cTxtLog += _EOL
Do Case
	Case _nOpc == 1
		_cFileLog	 	:= Criatrab(,.F.)
		_cLogPath		:= AllTrim(GetTempPath())+_cFileLog+".txt"
		_Handle			:= FCREATE(_cLogPath,0)	//| Arquivo de Log
		IF !EMPTY(_cTxtLog)
			FWRITE (_Handle, _cTxtLog)
		ENDIF
		
	Case _nOpc == 2
		IF !EMPTY(_cTxtLog)
			FWRITE (_Handle, _cTxtLog)
		ENDIF
		
	Case _nOpc == 3
		IF !EMPTY(_cTxtLog)
			FWRITE (_Handle, _cTxtLog)
		ENDIF
		FCLOSE(_Handle)
		WINEXEC("NOTEPAD "+_cLogPath)
EndCase

Return(_lRet)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณAjustSX1  บAutor  ณJonatas Oliveira    บ Data ณ 26/07/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAjusta as Perguntas.                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function AjustSX1(cPerg)

Local aArea := GetArea()
Local aHelpPor	:= {}
Local aHelpEng	:= {}
Local aHelpSpa	:= {}

aAdd( aHelpEng, "  ")
aAdd( aHelpSpa, "  ")

aHelpPor := {} ; Aadd( aHelpPor, "Data Importa็ใo De")
PutSx1( cPerg, "01","Data Importa็ใo De","","","mv_ch1","D",08,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )

aHelpPor := {} ; Aadd( aHelpPor, "Data Importa็ใo Ate")
PutSx1( cPerg, "02","Data Importa็ใo Ate","","","mv_ch2","D",08,0,0,"G","NaoVazio","","","","mv_par02","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )

aHelpPor := {} ; Aadd( aHelpPor, "Nota Fiscal De")
PutSx1( cPerg, "03","Nota Fiscal De","","","mv_ch3","C",09,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )

aHelpPor := {} ; Aadd( aHelpPor, "Nota Fiscal Ate")
PutSx1( cPerg, "04","Nota Fiscal Ate","","","mv_ch4","C",09,0,0,"G","","","","","mv_par04","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )

aHelpPor := {} ; Aadd( aHelpPor, "Fornecedor")
PutSx1( cPerg, "05","Fornecedor","","","mv_ch5","C",14,0,0,"G","","SA2CGC","","","mv_par05","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )

Return()



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณCP01CTEL  บAutor  ณThiago Nascimento  บ Data ณ 13/02/2014   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera faturas CTE em lote.                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function CP01CTEL()

Local cQuery := ""
Local nCount    := 0

PRIVATE _oDlg
PRIVATE  _lAbort  := .F.
PRIVATE _dDta     := CTOD("  /  /  ")
PRIVATE _lOkUsebt := .F.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Perguntas da Rotina ณ                         
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
SX1LOTCTE("CPE1CTE")

Pergunte("CPE1CTE",.T.)

cQuery := "	SELECT Z10.Z10_CHVNFE AS CHVCTE , Z10.Z10_VLRTOT AS VLRCTE FROM "+ RetSqlName("Z10") +" Z10 "
cQuery += "	LEFT OUTER JOIN "+ RetSqlName("Z14") +" Z14 "
cQuery += "	ON Z14.Z14_CHVCTE = Z10_CHVNFE "
cQuery += "	AND Z14.D_E_L_E_T_ = '' "
cQuery += "	WHERE Z10_FILIAL = '' "
cQuery += "	AND Z10_TIPARQ = 'C' "
cQuery += "	AND Z10_DTIMP BETWEEN '"+ DTOS(mv_par01) +"' AND '" + DTOS(mv_par02) + "' "
cQuery += "	AND Z10_DTNFE BETWEEN '" + DTOS(mv_par03) + "' AND '" + DTOS(mv_par04) + "' "
cQuery += "	AND Z10_CNPJ = '" + mv_par05 + "' "
cQuery += "	AND Z10_STATUS = '1' "
cQuery += "	AND NOT EXISTS ( "
cQuery += "	SELECT * FROM "+ RetSqlName("Z14") +" Z14S "
cQuery += "	WHERE Z14S.Z14_FILIAL = '' "
cQuery += "	AND Z14S.Z14_CHVCTE = Z10.Z10_CHVNFE) "	
	
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Close na TRB caso esteja em uso ณ                         
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
IF Select("TRBZ14") > 0
	TRBZ14->(DBCLOSEAREA())
ENDIF

dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),'TRBZ14')

DbSelectArea("TRBZ14")

TRBZ14->(DBGoTop())	
TRBZ14->( dbEval( {|| nCount++ } ) )	
TRBZ14->(DBGoTop())

IF nCount > 0
 
 //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
 //ณ Montagem da DIALOG p/ informar data ณ                         
 //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
  @ 220,184   To 345,517 Dialog _oDlg Title OemToAnsi("Informe Vencimento para CTE's")
  @ 002,002   To 61,167
  @ 025,025   Say OemToAnsi("Data") Size 52,8
  @ 024,060   Get _dDta  Size 55,08  
  @ 046,045   Button "_Ok"   Size 31,09 Action ACAO(1)  //Ok Senha 
  @ 046,085   Button "_Sair" Size 31,09 Action ACAO(2)  // Sair
  Activate  Dialog _oDlg Center
	
	// S๓ processa caso tenha fechado a Dialog pelo botใo OK.
	IF _lOkUsebt
		
		IF ! _lAbort 
			 
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
 			//ณ Static que chama Static de Grava็ใo ณ                         
	 		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			Processa({|| CHAMAGRV(nCount)},'Processando...')		
			
		ENDIF
		
	ENDIF
	
ELSE

	MSGINFO("Dados nใo encontrados com os parametros informados")
		
ENDIF

Return()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณACAO  บAutor  ณThiago Nascimento  บ Data ณ 13/02/2014   	  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณA็ใo dos botaos da DIALOG		                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function ACAO(nCall)

_lOkUsebt := .T.

IF nCall == 1

	IF  EMPTY(_dDta) .OR. _dDta < dDataBase 
		_lAbort := .T.
		MSGSTOP("Data de vencimento invแlida")
		Close(_oDlg)
		
	ELSE
		Close(_oDlg)
	ENDIF
	
ELSE
	_lAbort := .T.
	Close(_oDlg)
ENDIF

Return()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณCHAMAGRV บAutor ณThiago Nascimento  บ Data ณ 13/02/2014  	  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณChama fun็ใo de grava็ao dos titulos                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function CHAMAGRV(nCount)

PROCREGUA(nCount)

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Varredura nos registros da TRB ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
		WHILE TRBZ14->(! EOF())
			
			IncProc("Criando paracela para o CTE... ")

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
 			//ณ Static Functio que popula TABLE Z14 ณ                         
	 		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			GRAVAZ14(TRBZ14->CHVCTE, TRBZ14->VLRCTE)
				
			TRBZ14->(DBSKIP())
			
		ENDDO

Return()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณGRAVAZ14 บAutor ณThiago Nascimento  บ Data ณ 13/02/2014  	  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGrava titulos de CTE na tabela Z14                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GRAVAZ14(CHVCTE,VLRCTE)

Local nI
   	
   	REGTOMEMORY("Z14",.T.,.F.)
			 		    
		M->Z14_FILIAL := ""
		M->Z14_CHVCTE := CHVCTE 	 			 			  	 			  	 
		M->Z14_TIPARQ := "C"
		M->Z14_ITEM	  := "001"
		M->Z14_FATURA := "A"
		M->Z14_DTVENC := _dDta
		M->Z14_VALOR  := VLRCTE // Rotina de lote gera parcela unica.	
		M->Z14_VLRCTE := VLRCTE

		RECLOCK("Z14",.T.)
			For nI := 1 To  M->(FCOUNT()) //nTotCpo
			 	 FieldPut(nI,  M->&(FIELDNAME(nI)) )
			Next nI  
		Z14->(MSUNLOCK())	

Return()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณSX1LOTCTE  บAutor  ณThiago Nascimento  บ Data ณ 13/02/2014  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAjusta as Perguntas.                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function SX1LOTCTE(cPerg)

Local aArea := GetArea()
Local aHelpPor	:= {}
Local aHelpEng	:= {}
Local aHelpSpa	:= {}

aAdd( aHelpEng, "  ")
aAdd( aHelpSpa, "  ")

aHelpPor := {} ; Aadd( aHelpPor, "Data Importa็ใo De")
PutSx1( cPerg, "01","Data Importa็ใo De","","","mv_ch1","D",08,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )

aHelpPor := {} ; Aadd( aHelpPor, "Data Importa็ใo Ate")
PutSx1( cPerg, "02","Data Importa็ใo Ate","","","mv_ch2","D",08,0,0,"G","NaoVazio","","","","mv_par02","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )

aHelpPor := {} ; Aadd( aHelpPor, "Data Emissใo CTE de")
PutSx1( cPerg, "03","Data Emissใo CTE de","","","mv_ch3","D",08,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )

aHelpPor := {} ; Aadd( aHelpPor, "Data Emissใo CTE At้")
PutSx1( cPerg, "04","Data Emissใo CTE At้","","","mv_ch4","D",08,0,0,"G","NaoVazio","","","","mv_par04","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )

aHelpPor := {} ; Aadd( aHelpPor, "Fornecedor")
PutSx1( cPerg, "05","Fornecedor","","","mv_ch5","C",14,0,0,"G","","SA2CGC","","","mv_par05","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )

Return()


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCP01001J  บAutor  ณJonatas Oliveira    บ Data ณ  10/05/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณExclui XML nao com status diferente de gerado               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Engemav                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function CP01001J()
Local _nRecZ10 := Z10->(RECNO())  

DBSELECTAREA("Z10")
Z10->(DBSETORDER(1))
Z10->(DBGOTO(_nRecZ10))


DBSELECTAREA("Z11")
Z11->(DBSETORDER(1))//|Z11_FILIAL+Z11_CHVNFE

DBSELECTAREA("Z12")
Z12->(DBSETORDER(1))//|Z12_FILIAL+Z12_CHVNFE

DBSELECTAREA("Z13")
Z13->(DBSETORDER(1))//|Z13_FILIAL+Z13_CHVNFE

//|1=Nao Importado;2=Importado;3=Desconsiderado;4=Inconsistencia;5=Nota Gerada
IF Z10->Z10_STATUS <> "5" .AND. Z10->Z10_STATUS <> "2" 

	If ApMsgYesNo("Confirma a Exclusใo da Danfe"+Z10->Z10_NUMNFE+" ?" ,"Confirma็ใo de Exclusใo")
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณCABECALHO XMLณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู
/*		RECLOCK("Z10",.F.)
			Z10->Z10_USREXC := UsrRetName(__CUSERID)
			Z10->Z10_DTEXCL := DDATABASE
			Z10->Z10_HREXCL := TIME()
		MSUNLOCK()*/
	
		RECLOCK("Z10",.F.)
			Z10->(DBDELETE())
		MSUNLOCK()      
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณITEM XML     ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู		
		IF Z11->(DBSEEK(XFILIAL("Z11")+Z10->Z10_CHVNFE))
			WHILE Z11->(!EOF()) .AND. Z11->Z11_CHVNFE == Z10->Z10_CHVNFE
				
				RECLOCK("Z11",.F.)
					Z11->(DBDELETE())
				MSUNLOCK()
				
				Z11->(DBSKIP())
			ENDDO                      
		ENDIF 	
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณXML CANCELAMENTOณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		IF Z12->(DBSEEK(XFILIAL("Z12")+Z10->Z10_CHVNFE))
			WHILE Z12->(!EOF()) .AND. Z12->Z12_CHVNFE == Z10->Z10_CHVNFE
				
				RECLOCK("Z12",.F.)
					Z12->(DBDELETE())
				MSUNLOCK()
				
				Z12->(DBSKIP())
			ENDDO                      
		ENDIF 		
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณDUPLICATAS DANFEณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		IF Z13->(DBSEEK(XFILIAL("Z13")+Z10->Z10_CHVNFE))
			WHILE Z13->(!EOF()) .AND. Z13->Z13_CHVNFE == Z10->Z10_CHVNFE
				
				RECLOCK("Z13",.F.)
					Z13->(DBDELETE())
				MSUNLOCK()
				
				Z13->(DBSKIP())
			ENDDO                      
	
		ENDIF 		
    ELSE 
	    AVISO("AวรO ABORTADA", "Arquivo NรO excluํdo",{"Voltar"},3)	
	ENDIF 		
                       
ELSE
	AVISO("Nใo permitido", "Pre-nota/Nota Gerada",{"Voltar"},3)	
ENDIF

Return()


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CP0100ELบAutor  ณ Thiago Nascimento	 บ Data ณ  28/01/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Copia XML do Servidor para Maquina do usuแrio em Lote      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function CP0100EL()

Local cQuery := ""
Local nCount := 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Perguntas da Rotina ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
SX1LOTXML("CPE1XML")

Pergunte("CPE1XML",.T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Query da composi็ใo  ณ
//ณ dos lote de arquivos ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQuery := " SELECT Z10_NUMNFE, Z10_SERIE, Z10_CNPJ, Z10_RAZAO, Z10_ARQUIV FROM "+RetSqlName("Z10")+" "+CRLF
cQuery += " WHERE Z10_DTIMP BETWEEN '"+ DTOS(MV_PAR01) +"' AND '"+ DTOS(MV_PAR02) +"' "+CRLF
cQuery += " AND Z10_DTNFE BETWEEN   '"+ DTOS(MV_PAR03) +"' AND '"+ DTOS(MV_PAR04) +"' "+CRLF
cQuery += " AND Z10_NUMNFE BETWEEN  '"+ MV_PAR05 +"' AND '"+ MV_PAR06 +"' "+CRLF
cQuery += " AND Z10_SERIE BETWEEN   '"+ MV_PAR07 +"' AND '"+ MV_PAR08 +"' "+CRLF

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Filtro informado ณ
//ณ pelo usuแrio 	 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
IF ! EMPTY(MV_PAR09)
	cQuery += " AND Z10_CNPJ = '"+ MV_PAR09 +"' "+CRLF
ENDIF

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Filtro informado ณ
//ณ pelo usuแrio 	 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If MV_PAR10 == 1
	cQuery += " AND Z10_STATUS = '5'  "+CRLF
Elseif MV_PAR10 == 2
	cQuery += " AND Z10_STATUS <> '5'  "+CRLF
Endif

cQuery += " AND D_E_L_E_T_ = ''   "+CRLF

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Close na TRB caso esteja em uso ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
IF Select("TRBZ10") > 0
	TRBZ10->(DBCLOSEAREA())
ENDIF

dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),'TRBZ10')

DbSelectArea("TRBZ10")

TRBZ10->(DBGoTop())
TRBZ10->( dbEval( {|| nCount++ } ) )
TRBZ10->(DBGoTop())

// TRB precisa ter registro para entrar na rotina que procesa as c๓pias de arquivos.
IF 	nCount > 0
	
	MSGRUN("Copiando Arquivo, Aguarde...", "Copiando...", {||	Process(nCount) 	})
	
ELSE
	
	MSGINFO("Nenhum arquivo encontrado, verifique os parametros informados.")
	
ENDIF

Return()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ProcessบAutor  ณ Thiago Nascimento	 บ Data ณ  28/01/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Executa processamento da fun็ใo principal de copia de      บฑฑ
ฑฑบ          ณ arquivos                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function Process(nCount)

Local cPathOrig	:= LOWER(ALLTRIM(U_CP01005G("11", "XMLOK"))) //| Path do Servidor Protheus dos arquivos XML
Local cPathDest
Local cNomeArq	:= ""
Local cFullPath	:= ""
Local nTotCop  := 0

Private _cFileLog	 	:= ""
Private _cLogPath		:= ""
Private _Handle			:= ""

// Diret๓rio destino informado pelo usuแrio
cPathDest 	:= cGetFile('','Selecione Diret๓rio',1,,.F., nOR( GETF_LOCALHARD, GETF_NETWORKDRIVE, GETF_RETDIRECTORY ),.F., .T. )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicia Log ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤู
U_cpLogTxt(1)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ S๓ entra no la็o caso      ณ
//ณ TRB tenha + que 1 registro ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
IF nCount > 1
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Varredura nos registros da TRB ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	WHILE TRBZ10->(! EOF())
		
		cNomeArq	:= Lower(ALLTRIM(TRBZ10->Z10_ARQUIV))
		cFullPath	:= cPathOrig+cNomeArq
		
		// 1ช Valida็ใo para o registro posicionado da TRB
		IF ! EMPTY(cPathDest)
			
			// 2ช Valida็ใo para o registro posicionado da TRB, arquivo tem exister na Path Origem
			IF FILE(cFullPath)
				
				// 3ช Valida็ใo para o registro posicionado da TRB, arquivo nใo pode existir na Path Destino
				IF ! FILE(cPathDest+cNomeArq)
					
					__CopyFile(cFullPath, cPathDest+cNomeArq)
					u_cpLogTxt( 2 , "#Arquivo "+ ALLTRIM(TRBZ10->Z10_ARQUIV) + CRLF + "copiado com sucesso para Pasta:" + CRLF + cPathDest + CRLF +;
					"CNPJ: " + ALLTRIM(TRANSFORM(TRBZ10->Z10_CNPJ,"@R 99.999.999/9999-99")) + CRLF +;
					"Razใo Social: " + ALLTRIM(TRBZ10->Z10_RAZAO) + CRLF +;
					"Danfe/Serie: "+ ALLTRIM(TRBZ10->Z10_NUMNFE) + "/" + ALLTRIM(TRBZ10->Z10_SERIE) + CRLF +;
					REPLICATE("-",80) + CRLF)
					nTotCop++
				ELSE
					
					u_cpLogTxt( 2 , "#Arquivo "+ ALLTRIM(TRBZ10->Z10_ARQUIV) + CRLF + "jแ existe na pasta destino:" + CRLF + cPathDest +  CRLF +;
					"CNPJ: " + ALLTRIM(TRANSFORM(TRBZ10->Z10_CNPJ,"@R 99.999.999/9999-99")) + CRLF +;
					"Razใo Social: " + ALLTRIM(TRBZ10->Z10_RAZAO) + CRLF +;
					"Danfe/Serie: "+ ALLTRIM(TRBZ10->Z10_NUMNFE) + "/" + ALLTRIM(TRBZ10->Z10_SERIE) + CRLF +;
					REPLICATE("-",80) + CRLF )
					
				ENDIF
				
			ELSE
				
				u_cpLogTxt( 2 , "#Arquivo "+ ALLTRIM(TRBZ10->Z10_ARQUIV) + CRLF + "nใo encontrado na pasta origem:"+ CRLF + cPathOrig + CRLF +;
				"CNPJ: " + ALLTRIM(TRANSFORM(TRBZ10->Z10_CNPJ,"@R 99.999.999/9999-99")) + CRLF +;
				"Razใo Social: " + ALLTRIM(TRBZ10->Z10_RAZAO) + CRLF +;
				"Danfe/Serie: "+ ALLTRIM(TRBZ10->Z10_NUMNFE) + "/" + ALLTRIM(TRBZ10->Z10_SERIE)+ CRLF +;
				REPLICATE("-",80) + CRLF )
				
			ENDIF
			
		ENDIF
		
		TRBZ10->(DBSKIP())
		
	ENDDO
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณ Caso TRB     ณ
	//ณ	tenha apenas ณ
	//ณ 1 registro   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ELSE
	
	cNomeArq	:= Lower(ALLTRIM(TRBZ10->Z10_ARQUIV))
	cFullPath	:= cPathOrig+cNomeArq
	
	// 1ช Valida็ใo para o registro posicionado da TRB
	IF ! EMPTY(cPathDest)
		
		// 2ช Valida็ใo para o registro posicionado da TRB, arquivo tem exister na Path Origem
		IF FILE(cFullPath)
			
			// 3ช Valida็ใo para o registro posicionado da TRB, arquivo nใo pode existir na Path Destino
			IF ! FILE(cPathDest+cNomeArq)
				
				__CopyFile(cFullPath, cPathDest+cNomeArq)
				u_cpLogTxt( 2 , "#Arquivo "+ ALLTRIM(TRBZ10->Z10_ARQUIV) + CRLF + "copiado com sucesso para Pasta:" + CRLF + cPathDest + CRLF +;
				"CNPJ: " + ALLTRIM(TRANSFORM(TRBZ10->Z10_CNPJ,"@R 99.999.999/9999-99")) +  CRLF +;
				"Razใo Social: " + ALLTRIM(TRBZ10->Z10_RAZAO) +  CRLF +;
				"Danfe/Serie: "+ ALLTRIM(TRBZ10->Z10_NUMNFE) + "/" + ALLTRIM(TRBZ10->Z10_SERIE) + CRLF +;
				REPLICATE("-",80) + CRLF )
				nTotCop++
				
			ELSE
				
				u_cpLogTxt( 2 , "#Arquivo "+ ALLTRIM(TRBZ10->Z10_ARQUIV) + CRLF + "jแ existe na pasta destino:" + CRLF + cPathDest +  CRLF +;
				"CNPJ: " + ALLTRIM(TRANSFORM(TRBZ10->Z10_CNPJ,"@R 99.999.999/9999-99")) +  CRLF +;
				"Razใo Social: " + ALLTRIM(TRBZ10->Z10_RAZAO) +  CRLF +;
				"Danfe/Serie: "+ ALLTRIM(TRBZ10->Z10_NUMNFE) + "/" + ALLTRIM(TRBZ10->Z10_SERIE) + CRLF +;
				REPLICATE("-",80) + CRLF )
				
				
			ENDIF
			
		ELSE
			
			u_cpLogTxt( 2 , "#Arquivo "+ ALLTRIM(TRBZ10->Z10_ARQUIV) + CRLF + "nใo encontrado na pasta origem:"+ CRLF + cPathOrig + CRLF +;
			"CNPJ: " + ALLTRIM(TRANSFORM(TRBZ10->Z10_CNPJ,"@R 99.999.999/9999-99")) + CRLF +;
			"Razใo Social: " + ALLTRIM(TRBZ10->Z10_RAZAO) + CRLF +;
			"Danfe/Serie: "+ ALLTRIM(TRBZ10->Z10_NUMNFE) + "/" + ALLTRIM(TRBZ10->Z10_SERIE) + CRLF +;
			REPLICATE("-",80) + CRLF )
			
		ENDIF
		
	ENDIF
	
ENDIF

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Insere texto no FIM LOG ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
u_cpLogTxt(2, "TOTAL DE ARQUIVOS COPIADOS: "+ cValToChar(nTotCop) + CRLF)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Exibe Log ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤู
u_cpLogTxt(3)

Return()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณSX1LOTXML  บAutor  ณThiago Nascimento  บ Data ณ 28/01/2014  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAjusta as Perguntas.                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function SX1LOTXML(cPerg)

Local aArea := GetArea()
Local aHelpPor	:= {}
Local aHelpEng	:= {}
Local aHelpSpa	:= {}

aAdd( aHelpEng, "  ")
aAdd( aHelpSpa, "  ")

aHelpPor := {} ; Aadd( aHelpPor, "Data Importa็ใo De")
PutSx1( cPerg, "01","Data Importa็ใo De","","","mv_ch1","D",08,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )

aHelpPor := {} ; Aadd( aHelpPor, "Data Importa็ใo Ate")
PutSx1( cPerg, "02","Data Importa็ใo Ate","","","mv_ch2","D",08,0,0,"G","NaoVazio","","","","mv_par02","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )

aHelpPor := {} ; Aadd( aHelpPor, "Data Emissใo NF de")
PutSx1( cPerg, "03","Data Emissใo NF de","","","mv_ch3","D",08,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )

aHelpPor := {} ; Aadd( aHelpPor, "Data Emissใo NF At้")
PutSx1( cPerg, "04","Data Emissใo NF At้","","","mv_ch4","D",08,0,0,"G","NaoVazio","","","","mv_par04","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )

aHelpPor := {} ; Aadd( aHelpPor, "Nota fiscal de")
PutSx1( cPerg, "05","Nota fiscal de","","","mv_ch5","C",09,0,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )

aHelpPor := {} ; Aadd( aHelpPor, "Nota Fiscal At้")
PutSx1( cPerg, "06","Nota Fiscal Ate","","","mv_ch6","C",09,0,0,"G","","","","","mv_par06","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )

aHelpPor := {} ; Aadd( aHelpPor, "Serie de")
PutSx1( cPerg, "07","Serie de","","","mv_ch7","C",03,0,0,"G","","","","","mv_par07","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )

aHelpPor := {} ; Aadd( aHelpPor, "Serie At้")
PutSx1( cPerg, "08","Serie Ate","","","mv_ch8","C",03,0,0,"G","","","","","mv_par08","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )

aHelpPor := {} ; Aadd( aHelpPor, "Fornecedor")
PutSx1( cPerg, "09","Fornecedor","","","mv_ch9","C",14,0,0,"G","","SA2CGC","","","mv_par09","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )

aHelpPor := {} ; Aadd( aHelpPor, "Classifica็ใo XML")
PutSx1( cPerg, "10","Classifica็ใo XML","","","mv_cha","N",01,0,0,"C","","","","","mv_par10","Classificado","","","","Nใo Classificado","","","Ambos","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )

Return()



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณDESMITEM  บAutor  ณThiago Nascimento  บ Data ณ 29/04/2014   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBotใo desmembramento de item - MANUT.XML                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function DESMITEM()

Local nK

nQtdAt := oGetItem:Acols[oGetItem:nAt,nZ11QUANT]
nLinOrg   := oGetItem:nAt

// Posi็ใo do campo no Acols do Objeto MSGETNEWDADOS.
nZ11VALITE	    := aScan(aHdrItem,{|x| ALLTRIM(x[2])=="Z11_VLRUNI"})
nZ11VLRTOT		:= aScan(aHdrItem,{|x| ALLTRIM(x[2])=="Z11_VLRTOT"})
nZ11VLIBC		:= aScan(aHdrItem,{|x| ALLTRIM(x[2])=="Z11_ICBC"})
nZ11ICALQ		:= aScan(aHdrItem,{|x| ALLTRIM(x[2])=="Z11_ICALQ"})
nZ11ICVLR		:= aScan(aHdrItem,{|x| ALLTRIM(x[2])=="Z11_ICVLR"})
nZ11ICSTBC		:= aScan(aHdrItem,{|x| ALLTRIM(x[2])=="Z11_ICSTBC"})
nZ11ICSTAL		:= aScan(aHdrItem,{|x| ALLTRIM(x[2])=="Z11_ICSTAL"})
nZ11ICSTVL		:= aScan(aHdrItem,{|x| ALLTRIM(x[2])=="Z11_ICSTVL"})
nZ11IPIBC		:= aScan(aHdrItem,{|x| ALLTRIM(x[2])=="Z11_IPIBC"})
nZ11IPIVL		:= aScan(aHdrItem,{|x| ALLTRIM(x[2])=="Z11_IPIVLR"})
nZ11PISBC		:= aScan(aHdrItem,{|x| ALLTRIM(x[2])=="Z11_PISBC"})
nZ11PISALQ		:= aScan(aHdrItem,{|x| ALLTRIM(x[2])=="Z11_PISALQ"})
nZ11PISVL		:= aScan(aHdrItem,{|x| ALLTRIM(x[2])=="Z11_PISVLR"})
nZ11CFBC		:= aScan(aHdrItem,{|x| ALLTRIM(x[2])=="Z11_CFBC"})
nZ11CFALQ		:= aScan(aHdrItem,{|x| ALLTRIM(x[2])=="Z11_CFALQ"})
nZ11CFVL		:= aScan(aHdrItem,{|x| ALLTRIM(x[2])=="Z11_CFVLR"})

// Base de Calculo de ICMS - Linha Original
nBICMS  := oGetItem:Acols[oGetItem:nAt,nZ11VLIBC]
// Base de Calculo de ICMS_ST - Linha Original
nBICMST := oGetItem:Acols[oGetItem:nAt,nZ11ICSTBC]
// Base de Calculo de ICMS_ST - Linha Original
nBIPI   := oGetItem:Acols[oGetItem:nAt,nZ11IPIBC]
// Base de Calculo de ICMS_ST - Linha Original
nBPIS   := oGetItem:Acols[oGetItem:nAt,nZ11PISBC]
// Base de Calculo de ICMS_ST - Linha Original
nPCOF   := oGetItem:Acols[oGetItem:nAt,nZ11CFBC]

IF nQtdAt > 1
	
	// Solicito confirma็ใo ao Usuแrio
	IF MSGYESNO("Deseja desmembrar o item " + STRZERO(oGetItem:Acols[nLinOrg,nZ11ITEM],2) + "?")
		
		// Variแvel Private, para utilizar na fun็ใo Static GrvDados()
		lNewLin := .T.
		
		//Adiciono nova Linha no Acols
		oGetItem:AddLine(.T.,.F.)
		
		// Alimento dados da nova linha com informa็๕es da linha posicionada
		For nK := 1 To Len(oGetItem:Acols[nLinOrg])
			
			// Nใo prencho esses campos na nova linha do Acols
			If  nK <> nZ11ITEM .AND. nK <> nZ11QUANT
				oGetItem:Acols[oGetItem:nAt,nK] := oGetItem:Acols[nLinOrg,nK]
			Elseif nK == nZ11QUANT
				oGetItem:Acols[oGetItem:nAt,nK] := 0
			Endif
			
		Next nK
		
		//Habilito nova linda criada para edi็ใo do campo quantidade.
		AADD(oGetItem:aAlter,"Z11_QUANT")
		
		// Incluo Valida็ใo no CAMPO digitavel da Nova Linha
		oGetItem:bFieldOk := {|| u_VLDALL(nLinOrg,1) }
		
		// Atualizo Browser
		oGetItem:Refresh(.T.)
		
		
	ENDIF
	
ELSE
	MSGSTOP("Nใo ้ possํvel desmembrar item com quantidade igual a 1")
	
ENDIF

Return()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณVLDALL  บAutor  ณThiago Nascimento  	บ Data ณ 29/04/2014   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida็ใo do campo Quantidade - MANUT.XML                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function VLDALL(nLinOrg,nCall)

Local lRet 	  := .T.
Local nQtdNew, nQtdSub, nLinNew, nV

IF nCall == 1	.AND. __readvar =="M->Z11_QUANT"
	
	nQtdNew := 	M->Z11_QUANT
	nQtdSub := ( nQtdAt - M->Z11_QUANT )
	nLinNew := oGetItem:nAt
	
	// Nใo ้ possํvel quantidade maior que o item desmembrado.
	IF nQtdNew < nQtdAt
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณInicio recalculo da nova linha ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oGetItem:GoTo(nLinNew)
		
		oGetItem:Acols[oGetItem:nAt,nZ11VLRTOT]	:=	nQtdNew * oGetItem:Acols[oGetItem:nAt,nZ11VALITE]
		
		// LINHA NOVA - ICMS
		oGetItem:Acols[oGetItem:nAt,nZ11VLIBC]  :=  ( nBICMS / nQtdAt )* nQtdNew
		oGetItem:Acols[oGetItem:nAt,nZ11ICVLR]	:=	( oGetItem:Acols[oGetItem:nAt,nZ11ICALQ] * oGetItem:Acols[oGetItem:nAt,nZ11VLIBC] ) / 100
		
		// LINHA NOVA - ICMS - ST
		oGetItem:Acols[oGetItem:nAt,nZ11ICSTBC] := ( nBICMST / nQtdAt )* nQtdNew
		oGetItem:Acols[oGetItem:nAt,nZ11ICSTVL]	:= ( oGetItem:Acols[oGetItem:nAt,nZ11ICSTAL] * oGetItem:Acols[oGetItem:nAt,nZ11ICSTBC] ) / 100
		
		// LINHA NOVA - IPI
		oGetItem:Acols[oGetItem:nAt,nZ11IPIBC]  := ( nBIPI / nQtdAt )* nQtdNew
		oGetItem:Acols[oGetItem:nAt,nZ11IPIVL]	:= ( oGetItem:Acols[oGetItem:nAt,nZ11IPIALQ] * oGetItem:Acols[oGetItem:nAt,nZ11IPIBC] ) / 100
		
		// LINHA NOVA - PIS
		oGetItem:Acols[oGetItem:nAt,nZ11PISBC]  := ( nBPIS / nQtdAt )* nQtdNew
		oGetItem:Acols[oGetItem:nAt,nZ11PISVL]	:= ( oGetItem:Acols[oGetItem:nAt,nZ11PISALQ] * oGetItem:Acols[oGetItem:nAt,nZ11PISBC] ) / 100
		
		// LINHA NOVA - COFINS
		oGetItem:Acols[oGetItem:nAt,nZ11CFBC]   := ( nPCOF / nQtdAt )* nQtdNew
		oGetItem:Acols[oGetItem:nAt,nZ11CFVL]	:= ( oGetItem:Acols[oGetItem:nAt,nZ11CFALQ] * oGetItem:Acols[oGetItem:nAt,nZ11CFBC] ) / 100
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณInicio recalculo da linha originalณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oGetItem:GoTo(nLinOrg)
		
		// LINHA ORIGINAL - VALOR TOTAL
		oGetItem:Acols[oGetItem:nAt,nZ11QUANT]  :=  nQtdSub
		oGetItem:Acols[oGetItem:nAt,nZ11VLRTOT]	:=	nQtdSub * oGetItem:Acols[oGetItem:nAt,nZ11VALITE]
		
		// LINHA ORIGINAL - ICMS
		oGetItem:Acols[oGetItem:nAt,nZ11VLIBC]  :=  ( nBICMS / nQtdAt )* nQtdSub
		oGetItem:Acols[oGetItem:nAt,nZ11ICVLR]	:=	( oGetItem:Acols[oGetItem:nAt,nZ11ICALQ] * oGetItem:Acols[oGetItem:nAt,nZ11VLIBC] ) / 100
		
		// LINHA ORIGINAL - ICMS - ST
		oGetItem:Acols[oGetItem:nAt,nZ11ICSTBC] := ( nBICMST / nQtdAt )* nQtdSub
		oGetItem:Acols[oGetItem:nAt,nZ11ICSTVL]	:= ( oGetItem:Acols[oGetItem:nAt,nZ11ICSTAL] * oGetItem:Acols[oGetItem:nAt,nZ11ICSTBC] ) / 100
		
		// LINHA ORIGINAL - IPI
		oGetItem:Acols[oGetItem:nAt,nZ11IPIBC]  := ( nBIPI / nQtdAt )* nQtdSub
		oGetItem:Acols[oGetItem:nAt,nZ11IPIVL]	:= ( oGetItem:Acols[oGetItem:nAt,nZ11IPIALQ] * oGetItem:Acols[oGetItem:nAt,nZ11IPIBC] ) / 100
		
		// LINHA ORIGINAL - PIS
		oGetItem:Acols[oGetItem:nAt,nZ11PISBC]  := ( nBPIS / nQtdAt )* nQtdSub
		oGetItem:Acols[oGetItem:nAt,nZ11PISVL]	:= ( oGetItem:Acols[oGetItem:nAt,nZ11PISALQ] * oGetItem:Acols[oGetItem:nAt,nZ11PISBC] ) / 100
		
		// LINHA ORIGINAL - COFINS
		oGetItem:Acols[oGetItem:nAt,nZ11CFBC]   := ( nPCOF / nQtdAt )* nQtdSub
		oGetItem:Acols[oGetItem:nAt,nZ11CFVL]	:= ( oGetItem:Acols[oGetItem:nAt,nZ11CFALQ] * oGetItem:Acols[oGetItem:nAt,nZ11CFBC] ) / 100
		
		//nQtdAt:= 0
		
	ELSE
		//Bloqueio de dados invแlidos
		lRet:= .F.
		MSGSTOP("Nใo ้ possํvel inserir valor superior ao desmembramento")
		
	ENDIF
	
ELSE
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณValida็ใo do tudoOK	ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	For nV := 1 To Len(oGetItem:Acols)
		
		If oGetItem:Acols[nV,nZ11QUANT] ==  0
			MSGSTOP("O item " + STRZERO(oGetItem:Acols[nV,nZ11ITEM],2) + " estแ com a quantidade Zerada.")
			lRet := .F.
		Endif
		
	Next nV
	
	
ENDIF

Return(lRet)