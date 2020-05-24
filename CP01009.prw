#Include "Protheus.Ch"
#Include "Rwmake.Ch"
#INCLUDE 'TBICONN.CH'
//#include "ApLib080.ch"


#DEFINE EOL			chr(13)+chr(10)
#DEFINE aAliasM2	"Z07"							
#DEFINE cChave		"Z07->(Z07_FILIAL+Z07_TIPO+Z07_CFOP)"		//| Chave do Cabecalho
#DEFINE nIndChv		1

//| Indice e chave Unica  - Utilizado na Alteracao e Exclusao
#DEFINE nIndUniq	1
                    

STATIC nZ07FILTRO 
 


  
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CP01009  บAutor  ณAugusto Ribeiro     บ Data ณ 04/04/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Configurador de importacao de Nota Fiscal                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ                    
ฑฑบUso       ณ      	                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function CP01009()
Private cCenario, _cRevCen,	cNomCena, _cMSBLQL,	_dDtIni, _dDtFim
Private INCLUI,	ALTERA
Private cLinhaOk	:= "U_CP0109VL()"
Private cTudoOk		:= ".T." 
Private cIniCpos := "+Z07_ITEM" // String com o nome dos campos que devem inicializados ao pressionar a seta para baixo.

Private aAC,cTITULO , cCADASTRO , lEND, cDELFUNC, aROTINA

Private aCabec	:= {}                              
Private aChvUnq	:= {}


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria HELPs utilizados na rotina ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//	AjustaHlp()		

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ CABECALHO - Defini็coes do cabelho                         ณ
	//ณ aCabec[<cCAMPO>, <VAR>, <nLINHA>, <nCOLUNA>, <cVALIDACAO>] ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//AADD(aCabec,{"Z07_FILIAL",,15, 10, ".T." }) // Adicionado por Thiago Nascimento, para atender como tabela exclusiva.
	AADD(aCabec,{"Z07_TIPO"  ,,15, 40, ".T." })	
	AADD(aCabec,{"Z07_CFOP"  ,,15, 80, ".T." })
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Campos que compeem a chave Unica ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aChvUnq	:= {"Z07_FILIAL","Z07_TIPO", "Z07_CFOP", "Z07_ITEM"}																						
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Campo com ID UNICO Sequencial - Somente utlizado na Gravacao     ณ
	//ณ Nunca se repete mesmo que o registro seja deletado               ณ
	//ณ {<cCAMPO>, <cFuncao Gera Unico> }                                ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//	aIDUniq	:= {"POO_ID", "GetUniq()"}


	aAC:={"Abandona","Confirma"}
	cTitulo := "Identifica TES"
	cCadastro := OemToAnsi (cTitulo)
	lEnd := .F.                               	
	CdelFunc := ".T."
	
	aRotina := {{"Pesquis","AxPesqui ", 0, 1},;
	{"Visual"	,"U_CP01009A(2)", 0, 2},;
	{"Incluir"	,"U_CP01009A(3)", 0, 3},;
	{"Alterar"	,"U_CP01009A(4)", 0, 4},;
	{"Exclusao"	,"U_CP01009A(5)", 0, 5}}
	
	dbSelectArea(aAliasM2) 
	dbSetOrder(nIndChv)
	mBrowse(06,01,22,75,aAliasM2,,,30)
Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CP01009A บAutor  ณAugusto Ribeiro     บ Data ณ  05/04/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Configurador 	                                          บฑฑ
ฑฑบ          ณ | Inclusao/Alteracao/Exclusao                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function CP01009A(cOpcao)     
Local nGrava, cQuebra          
Local nScan		:= 0 
Local cChvReg	:= ""
Local aPosChv	:= {}  
Local aCpoLog	:= {} 	//| LOG
Local aButtons	:= {}

//aAliasM2 	:= "Z07"
//nIndChv 	:= 1
//cChave		:=	"Z07->(Z07_TIPO+Z07_CFOP)"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Opcao de acesso para o Modelo 2                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza
nOpcx:=cOpcao     


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montando aHeader                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("SX3")
SX3->(dbSetOrder(1))
SX3->(dbSeek(aAliasM2))   

nUsado	:= 0
aHeader	:= {}

While SX3->(!Eof()) .And. (SX3->x3_arquivo == aAliasM2)

	nScan	:= Ascan(aCabec,{|x| Alltrim(Upper(x[1]))==Alltrim(SX3->X3_CAMPO)})        

	If nScan <> 0 //Alltrim(SX3->X3_CAMPO)=="POU_CENARI" //.OR. Alltrim(SX3->X3_CAMPO)=="POM_FILUSO" 
		      
		        
		aadd(aCabec[nScan],SX3->X3_CONTEXT)
		SX3->(dbSkip())
		Loop
	EndIf	

	IF X3USO(x3_usado) .AND. cNivel >= x3_nivel
		nUsado:=nUsado+1
		AADD(aHeader,{ TRIM(x3_titulo),;
						x3_campo,;
						x3_picture,;
						x3_tamanho,;
						x3_decimal,;
						x3_valid,;
						x3_usado,;
						x3_tipo,;
						x3_arquivo,;
						x3_context } )
	Endif
	SX3->(dbSkip())
EndDo
       

nZ07FILTRO 	:= Ascan(aHeader,{ |x| alltrim(x[2]) == "Z07_FILTRO" } )


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ                 ณ
//ณ MONTA INTERFACE ณ
//ณ                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//ฺฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inclusao ณ
//ภฤฤฤฤฤฤฤฤฤฤู
If nOpcx==3 
	INCLUI	:= .T.
	ALTERA	:= .F.
	aCols := Array(1,nUsado+1)
	dbSelectArea("SX3")
	SX3->(dbSeek(aAliasM2))
	
	nUsado:=0
	
	While SX3->(!Eof()) .And. (x3_arquivo == aAliasM2)
	
		If Ascan(aCabec,{|x| Alltrim(Upper(x[1]))==Alltrim(SX3->X3_CAMPO)}) <> 0		
			dbSelectArea("SX3")
		   	SX3->(dbSkip())
			Loop
			
		EndIf	

		IF X3USO(x3_usado) .AND. cNivel >= x3_nivel
			nUsado++                
			IF nOpcx == 3           
				aCOLS[1][nUsado]	:= CRIAVAR(SX3->X3_CAMPO, .T.)
			Endif
		Endif
		SX3->(dbSkip())
	EndDO              
	
	aCOLS[1][nUsado+1] := .F.	//| Delete
	aCOLS[1,1]	:= "001"     
	

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ alteracao/exclusao/visualizacao ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ElseIf nOpcx <> 3 
	INCLUI	:= .F.
	ALTERA	:= .T.

	aCols:={}
		
	dbSelectArea(aAliasM2)
	(aAliasM2)->(dbSetOrder(nIndChv))
	(aAliasM2)->(dbSeek(&(cChave)))  
	
	REGTOMEMORY(aAliasM2, .F.)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ CABECALHO ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤู
	FOR _ni := 1 TO LEN(aCabec)
		aCabec[_ni,2]	:=	M->&(aCabec[_ni,1]) 
	NEXT _ni	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ ITENS -  Monta aCols ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cQuebra	:=	&(cChave)
	While (aAliasM2)->(!Eof()) .And. cQuebra == &(cChave)
	
		AADD(aCols,Array(nUsado+1))
		
		REGTOMEMORY(aAliasM2, .F.)		
		
		For _ni:=1 to nUsado       
			aCols[Len(aCols),_ni]	:=	M->&(aHeader[_ni,2])
		Next
		
		aCols[Len(aCols),nUsado+1]	:=	.F.
		
		(aAliasM2)->( dbSkip() )
	Enddo                      
	
EndIf 
      
       
aAreaSX3	:= SX3->(GetArea())	
SX3->(DBSETORDER(2))

aC:={}
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Array com descricao dos campos do Cabecalho do Modelo 2      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
// aC[n,1] = Nome da Variavel Ex.:"cCliente"
// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aC[n,3] = Titulo do Campo
// aC[n,4] = Picture
// aC[n,5] = Validacao
// aC[n,6] = F3
// aC[n,7] = Se campo e' editavel .t. se nao .f.


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ CABECALHO MODELO 2 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nOpcx==3

//	REGTOMEMORY(aAliasM2,.T.)  

	FOR ni := 1 TO LEN(aCabec)
		aCabec[nI,2]	:= CriaVar(aCabec[nI,1],.T.)   
                                
		//| Posiciona SX3
		SX3->(DBSEEK(aCabec[nI,1],.F.))
		                                
		cValidCpo	:= IIF(EMPTY(SX3->X3_VALID),".T. ",SX3->X3_VALID)+" .AND. "+IIF(EMPTY(SX3->X3_VLDUSER)," .T.",SX3->X3_VLDUSER)
		AADD(aC,{"aCabec["+alltrim(str(ni))+",2]"	,{aCabec[nI,3], aCabec[nI,4]}  ,ALLTRIM(SX3->X3_TITULO)   ,SX3->X3_PICTURE	,cValidCpo,SX3->X3_F3, IIF(SX3->X3_VISUAL == "V",.F., &(SX3->X3_WHEN))	})

	NEXT nI

	
Else

	(aAliasM2)->(dbSeek(cQuebra))

	FOR ni := 1 TO LEN(aCabec) 
	
		//| Posiciona SX3
		SX3->(DBSEEK(aCabec[nI,1],.F.))
			
		AADD(aC,{"aCabec["+alltrim(str(ni))+",2]"	,{aCabec[nI,3], aCabec[nI,4]}  ,ALLTRIM(SX3->X3_TITULO)   ,SX3->X3_PICTURE	, aCabec[nI,5] ,SX3->X3_F3, IIF(SX3->X3_VISUAL == "V",.F., &(SX3->X3_WHEN))	})					
	NEXT nI	
	
EndIf  

RestArea(aAreaSX3)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Array com descricao dos campos do Rodape do Modelo 2         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aR:={}
// aR[n,1] = Nome da Variavel Ex.:"cCliente"
// aR[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aR[n,3] = Titulo do Campo
// aR[n,4] = Picture
// aR[n,5] = Validacao
// aR[n,6] = F3
// aR[n,7] = Se campo e' editavel .t. se nao .f.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Array com coordenadas da GetDados no modelo2                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aCGD:={85,5,118,315} 
                                      
Aadd( aButtons, {"FILTRO",{ || aCols[n,nZ07FILTRO] :=  MakeFil(aCabec[1,2],alltrim(aCols[n,nZ07FILTRO]))},"Abortar Operacao", "Filtro"} )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Chamada da Modelo2                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
lRetMod2 := Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk, , , cIniCpos,999999,,,,aButtons)    //| [ aCordW ] [ lDelGetD ] [ lMaximazed ] [ aButtons ] )



//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ                    ณ
//ณ GRAVACAO DOS DADOS ณ
//ณ                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lRetMod2    
                              
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ *** INCLUSAO *** ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If nOpcx==3
		For nGrava:=1 To Len(aCols)
		                                   
			//| Desconsidera registro deletado
			If Acols[nGrava,Len(aHeader)+1]
				Loop
			EndIf


			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Alimenta campo do Cabecalho ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			RecLock( aAliasM2,.T.)
			Z07->Z07_FILIAL := XFILIAL("Z07")
			FOR nX	:= 1 TO LEN(aCabec)
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Desconsidera campos virtuais ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				IF aCabec[nX, Len(aCabec[nX])]	<> "V"
					&(aAliasM2+"->"+aCabec[nX,1])		:= aCabec[nX,2]
					
				ENDIF
			Next nX


			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Alimenta Campo dos Itens ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			For nX:=1 To Len(aHeader)    
				IF aHeader[nX,10] <> "V"

					&(aAliasM2+"->"+aHeader[nX,2])	:= 	Acols[nGrava,nX]
				ENDIF				
			Next nX
			MsUnLock()             
			ConfirmSx8()
			                        
		
		Next  nGrava
		
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ *** ALTERACAO *** ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	ElseIf nOpcx==4
	    
	    dbSelectArea(aAliasM2)
	    dbSetOrder(nIndChv)
	    
		For nGrava:=1 To Len(aCols)         
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Monta Chave ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู
			cChvReg	:= XFILIAL(aAliasM2)				
			FOR nI := 1 TO LEN(aChvUnq)
	                     
	  			//| Cabec
				nPos	:=	Ascan(aCabec,{|x| Alltrim(Upper(x[1]))== aChvUnq[nI]  })
				IF nPos <> 0                                                          
					cChvReg	+= 	aCabec[nPos,2] //|aCols[nGrava, aPosChv[nI]] 					
				ENDIF		
	                                             
				//| Itens
				nPos	:=	Ascan(aHeader,{|x| Alltrim(Upper(x[2]))== aChvUnq[nI]  })
				IF nPos <> 0                                                          
					cChvReg	+= aCols[nGrava, nPos] 					
				ENDIF
			Next nI				
				

			          
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Posiciona no registro a ser Alterado ou Excluido ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู			
			IF Z07->(DBSEEK(cChvReg,.F.))   
			
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ EXCLUSAO                                                         ณ
				//ณ Caso linha tenha sido deletada, EXCLUI registro da tabela Fisica ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				If Acols[nGrava,Len(aHeader)+1]
					RECLOCK(aAliasM2,.F.)
						(aAliasM2)->(DBDELETE())				
					MSUNLOCK()

					LOOP
				EndIf			
				
			     
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ ALTERACAO                                                        ณ
				//ณ                                                                  ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

				//ฺฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ CABECALHO ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤู
				FOR nI := 1 TO LEN(aCabec)
					M->&(aCabec[nI,1])	:= aCabec[nI,2]									
				Next nI				

				//ฺฤฤฤฤฤฤฤฟ
				//ณ ITENS ณ
				//ภฤฤฤฤฤฤฤู
				FOR nI := 1 TO LEN(aHeader)
					IF aHeader[nI,10] <> "V"
						M->&(aHeader[nI,2])	:= aCols[nGrava,nI]									
					ENDIF
				Next nI
			

				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Grava Alteracao ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 
				nCpoAlt	:= 0  
				For nY := 1 To (aAliasM2)->(FCOUNT())                    
					     
					//| Armazena dados para gravacao do LOG
					IF (aAliasM2)->&(FieldName(nY)) <> M->&(FieldName(nY))
						aAdd( aCpoLog , { FieldName(nY) , (aAliasM2)->&(FieldName(nY)) , M->&(FieldName(nY)) } )	
						
						nCpoAlt++
						
						//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
						//ณ Otimizacao de Performance                               ณ
						//ณ Somente abre transacao se ao menos 1 campo foi alterado ณ
						//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
						IF nCpoAlt == 1
							RECLOCK(aAliasM2, .F.)	
						ENDIF

						(aAliasM2)->&(FieldName(nY))	:= M->&(FieldName(nY))						
					ENDIF
				Next nY				                                       

				(aAliasM2)->(MSUNLOCK())
				aCpoLog	:= {}
				
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ INCLUSAO                                                         ณ
			//ณ Quando o registro nao e localizado,inclui registro               ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู			
			ELSE    				


				//| Desconsidera registros deletados 				
				If Acols[nGrava,Len(aHeader)+1]
					
					LOOP
				EndIf				
			                                       
			       
			
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Alimenta campo do Cabecalho ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				RecLock( aAliasM2,.T.)
				Z07->Z07_FILIAL := XFILIAL("Z07")	
				FOR nX	:= 1 TO LEN(aCabec)
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณ Desconsidera campos virtuais ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					IF aCabec[nX, Len(aCabec[nX])]	<> "V"
						&(aAliasM2+"->"+aCabec[nX,1])		:= aCabec[nX,2]
						
					ENDIF
				Next nX
	
	
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Alimenta Campo dos Itens ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				For nX:=1 To Len(aHeader) 
					IF aHeader[nX,10] <> "V" 
					
						&(aAliasM2+"->"+aHeader[nX,2])	:= 	Acols[nGrava,nX]
					ENDIF
				Next
				MsUnLock() 

			ENDIF 
			
		Next nGrava	
		           
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ *** EXCLUSAO *** ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	ElseIf nOpcx==5	 
	
		dbSelectArea(aAliasM2)
		(aAliasM2)->(dbSetOrder(nIndChv))
		(aAliasM2)->(dbSeek(&(cChave)))  		

		cQuebra	:=	&(cChave)
		While (aAliasM2)->(!Eof()) .And. cQuebra == &(cChave)
				
			RECLOCK(aAliasM2, .F.)			
				(aAliasM2)->(DBDELETE())			
			MSUNLOCK()
			
			(aAliasM2)->(dbSkip())
		Enddo		
	Endif 
ELSE
	ROLLBACKSX8()
	      
Endif

Return()







/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CP01009  บAutor  ณAugusto Ribeiro     บ Data ณ 05/04/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Identifica a TES a ser utilizada                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบParametrosณ cTipo	: E=Entrada/S=Saida                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ *** E=Entrada ***                                          บฑฑ
ฑฑบ          ณ aRecnoCad	: {nSF1, nSD1, nSB1, nSA2}                    บฑฑ
ฑฑบ          ณ aChave		: {cDoc, cSerie, cFor, cLoja, cCodPro, cItem }บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ *** S=Saida ***                                            บฑฑ
ฑฑบ          ณ aRecnoCad	: {nSA1, nSB1}                                บฑฑ
ฑฑบ          ณ aChave		: {cChvSA1, cChvSB1}                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ lRestArea	: Executa Get e Rest Area?                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function CP01009T(cTipo, aRecnoCad, aChave, lRestArea)
Local cRet			:= ""
Local nRecnoCad
Local lFindReg		:= .F. 
Local cExpressao	:= ""  
Local aArea			:= GetArea() 
Local aAreaSF1, aAreaSD1, aAreaSB1, aAreaSA2, aAreaSA1, aAreaSA2
Local lTesProd		:= U_CP01005G("11", "TESPROD")//|Atribui TES vinculada ao Produto?

Default aRecnoCad := {}
            
nRecnoCad	:= LEN(aRecnoCad)               

DBSELECTAREA("Z10")
DBSELECTAREA("Z11") 	

aAreaZ10	:= Z10->(GetArea())
aAreaZ11	:= Z11->(GetArea())
    
IF cTipo == "E"
    
	DBSELECTAREA("SF1")
	DBSELECTAREA("SD1")
	DBSELECTAREA("SB1")
	DBSELECTAREA("SA2") 
	
	aAreaSF1	:= SF1->(GetArea())
	aAreaSD1	:= SD1->(GetArea())
	aAreaSB1	:= SB1->(GetArea())
	aAreaSA2	:= SA2->(GetArea())
	               
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Posiciona Tabelas ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	IF nRecnoCad >= 1
		SF1->(DBGOTO(aRecnoCad[1]))    
		lFindReg	:= .T.
	ELSE   
		SF1->(DBSETORDER(1)) //| F1_FILIAL, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, F1_TIPO
		lFindReg	:= SF1->(DBSEEK(xFilial("SF1")+aChave[1]+aChave[2]+aChave[3]+aChave[4]))
	ENDIF
	
	IF lFindReg
		IF nRecnoCad >= 2
			SD1->(DBGOTO(aRecnoCad[3]))    
			lFindReg	:= .T.
		ELSE   
			SD1->(DBSETORDER(1)) //| D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_ITEM
			lFindReg	:= SD1->(DBSEEK(SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)+aChave[5]+aChave[6]))
		ENDIF	
	ENDIF  
	
	IF lFindReg
		IF nRecnoCad >= 3
			SB1->(DBGOTO(aRecnoCad[4]))    
			lFindReg	:= .T.
		ELSE   
			SB1->(DBSETORDER(1))
			lFindReg	:= SB1->(DBSEEK(xFilial("SB1")+SD1->D1_COD))
		ENDIF	
	ENDIF	

	IF lFindReg
		IF nRecnoCad >= 3
			SA2->(DBGOTO(aRecnoCad[4]))    
			lFindReg	:= .T.
		ELSE   
			SA2->(DBSETORDER(1))
			lFindReg	:= SA2->(DBSEEK(xFilial("SA2")+SF1->(F1_FORNECE+F1_LOJA) ))
		ENDIF	
	ENDIF  
	
	IF lFindReg
		Z10->(DBSETORDER(1)) //| Z10_FILIAL, Z10_CHVNFE, Z10_TIPARQ
		lFindReg	:= Z10->(DBSEEK(xFilial("Z10")+SF1->F1_CHVNFE+"E"))

		IF !lFindReg
			Z10->(DBSETORDER(1)) //| Z10_FILIAL, Z10_CHVNFE, Z10_TIPARQ
			lFindReg	:= Z10->(DBSEEK(xFilial("Z10")+SF1->F1_CHVNFE+"C"))
		ENDIF 	

	ENDIF 	
	
	
	IF lFindReg
		Z11->(DBSETORDER(1)) //| Z10_FILIAL, Z10_CHVNFE, Z10_TIPARQ
		lFindReg	:= Z11->( DBSEEK( Z10->( Z10_FILIAL + Z10_CHVNFE + Z10_TIPARQ ) + ALLTRIM( SD1->D1_XITEXML) ))
	ENDIF 	
	
	
	IF lFindReg		
		
		/*----------------------------------------
			28/06/2019 - Jonatas Oliveira - Compila
			Verifica se TES estแ vinculada ao Produto
		------------------------------------------*/
		IF lTesProd
			SB1->( DBSETORDER(1))
			IF SB1->( DBSEEK( XFILIAL("SB1") + SD1->D1_COD ))
				IF !EMPTY(SB1->B1_TE)
					cRet := SB1->B1_TE
				ENDIF 
			ENDIF 
		ENDIF
		
		IF EMPTY(cRet)		
			
			DBSELECTAREA("Z07")	
			Z07->(DBSETORDER(1)) //| Z07_FILIAL, Z07_TIPO, Z07_CFOP, Z07_ITEM
		                                        
			cCFOP	:= RIGHT(alltrim(SD1->D1_CF),3)
			
			IF EMPTY(cCFOP)
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Converte CFOP de Saida para Entrada ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				cCFOP	:= Z11->Z11_CFOP
				cCFOP	:= RIGHT(ConvCFOP(cCFOP),3)			
			ENDIF 
			
			IF Z07->(DBSEEK(XFILIAL("Z07")+"E"+cCFOP))
				WHILE Z07->(!EOF()) .AND. Z07->Z07_CFOP == cCFOP
				
					IF &(ALLTRIM(Z07->Z07_FILTRO))
						cRet	:= Z07->Z07_TES
						EXIT
					ENDIF
							         
					Z07->(DBSKIP())
				ENDDO
			ENDIF
		ENDIF
		
	ENDIF 
	
	
	RestArea(aAreaSF1)
	RestArea(aAreaSD1)
	RestArea(aAreaSB1)
	RestArea(aAreaSA2) 
	

ELSEIF cTipo == "S"

	DBSELECTAREA("SB1")
	DBSELECTAREA("SA1") 
	DBSELECTAREA("SA2")

	aAreaSB1	:= SB1->(GetArea())
	aAreaSA1	:= SA1->(GetArea())
	aAreaSA2	:= SA2->(GetArea())    		                 
    
	IF nRecnoCad >= 1
		SA1->(DBGOTO(aRecnoCad[1]))    
		lFindReg	:= .T.
	ELSEIF Z10->Z10_TIPNFE == "D" .OR. Z10->Z10_TIPNFE == "B"
		SA2->(DBSETORDER(1))
		lFindReg	:= SA2->(DBSEEK(xFilial("SA2")+aChave[1] ))
	ELSE   
		SA1->(DBSETORDER(1))
		lFindReg	:= SA1->(DBSEEK(xFilial("SA1")+aChave[1] ))
	ENDIF

	IF lFindReg
		IF nRecnoCad >= 2
			SB1->(DBGOTO(aRecnoCad[2]))
			lFindReg	:= .T.
		ELSE   
			SB1->(DBSETORDER(1))
			lFindReg	:= SB1->(DBSEEK(xFilial("SB1")+aChave[2]))
		ENDIF
	ENDIF 
	
	
	IF lFindReg		                                                                    
		
		DBSELECTAREA("Z07")	
		Z07->(DBSETORDER(1)) //| Z07_FILIAL, Z07_TIPO, Z07_CFOP, Z07_ITEM
	                                        
		cCFOP	:= RIGHT(alltrim(Z11->Z11_CFOP),3)		
		IF Z07->(DBSEEK(XFILIAL("Z07")+"S"+cCFOP))
			WHILE Z07->(!EOF()) .AND. Z07->Z07_CFOP == cCFOP
			
				IF &(ALLTRIM(Z07->Z07_FILTRO))
					cRet	:= Z07->Z07_TES
					EXIT
				ENDIF
						         
				Z07->(DBSKIP())
			ENDDO
		ENDIF
		
	ENDIF 	

	RestArea(aAreaSB1)
	RestArea(aAreaSA1) 

ENDIF   


RestArea(aAreaZ10)
RestArea(aAreaZ11)
RestArea(aArea)

Return(cRet)




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMakeFil   บAutor  ณAugusto Ribeiro     บ Data ณ 06/04/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta Expressao de Filtro 	                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MakeFil(cTipo,cMemoSF1)
Local cRet		:= cMemoSF1
Local oDlgFil	:= Nil
Local oMemoSF1  := Nil
Local oMemoSD1  := Nil
//Local cMemoSF1  := ""
Local cMemoSD1  := ""
Local oFilSF1	:= Nil
Local oFilSD1	:= Nil
Local oOk		:= Nil
Local oCombo 	:= Nil
Local nCombo 	:= 1
Local aCombo	:= {}
Local aTabelas	:= {}
Local oMonoAs  	:= TFont():New( "Courier New",6,0) 			// Fonte para o campo Memo
Local bFilSF1	:= {|| ( cRet := CorrigExp(BuildExpr(aTabelas[nCombo],,cRet,.T. )) )  }
// BuildExpr ( cAlias [ oWnd ] [ cFilter ] [ lTopFilter ] [ bOk ] [ oDlg ] [ aUsado ] [ cDesc ] [ nRow ] [ nCol ] [ aCampo ] [ lVisibleTopFilter ] [ lExpBtn ] [ cTopFilter ] ) --> cRet
//Local bFilSD1	:= {|| ( cMemoSD1 := BuildExpr("SD1",,cMemoSD1)) }
Local bOk		:= {|| oDlgFil:End() }
                         
cTipo	:= alltrim(cTipo)

IF EMPTY(cTipo)
	Help( ,, 'HELP',, 'Campo Tipo invแlido.', 1, 0)
	return("")
ELSEIF cTipo == "E"
	aCombo		:= {"SF1-Cabec. Nota Fiscal","SD1-Itens Nota Fiscal", "SB1-Cad. Produtos", "SA2-Cad. Fornecedores", "Z10-Cabec XML", "Z11-Itens XML"}
	aTabelas	:= {"SF1", "SD1","SB1","SA2", "Z10", "Z11"}  
ELSEIF cTipo == "S"
	aCombo		:= {"SA1-Cad. Clientes","SB1-Cad. Produtos", "Z10-Cabec XML", "Z11-Itens XML"}
	aTabelas	:= {"SA1","SB1", "Z10", "Z11"}  
ENDIF

DEFINE MSDIALOG oDlgFil TITLE "Filtro" FROM 000,000 To 230,493 OF oMainWnd PIXEL
      

@016,005  SAY "Tabela:" PIXEL OF oDlgFil
@014,023  MsComboBox oCombo VAR nCombo ITEMS aCombo SIZE 060, 200 OF oDlgFil PIXEL ON CHANGE nCombo := oCombo:nAt

//ฺฤฤฤฤฤฤฤฤฤฤฟ
//ณCabecalho.ณ
//ภฤฤฤฤฤฤฤฤฤฤู
@005,002 To 095,246 LABEL "Filtro" OF oDlgFil PIXEL

@100,008 BTNBMP oFilSF1 RESOURCE "FILTRO" SIZE 20,20 DESIGN ACTION Eval(bFilSF1) OF oDlgFil PIXEL MESSAGE "Criar expressใo de Filtro"

@030,016 GET oMemoSF1 VAR cRet OF oDlgFil MEMO SIZE 227,055 PIXEL //READONLY
oMemoSF1:oFont := oMonoAs


@200,440 BTNBMP oOk RESOURCE "CANCEL" SIZE 20,20 DESIGN ACTION eval({|| cRet := cMemoSF1, oDlgFil:End()}) OF oDlgFil MESSAGE "Cancelar"

@200,470 BTNBMP oOk RESOURCE "OK" SIZE 20,20 DESIGN ACTION Eval(bOk) OF oDlgFil MESSAGE "OK"

ACTIVATE MSDIALOG oDlgFil CENTERED

Return(cRet)




/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CorrigExpบAutor  ณAugusto Ribeiro     บ Data ณ 06/04/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Corrige expressao de Filtro para que marcro subistitui็ใo  บฑฑ
ฑฑบ          ณseja executada sem falhas                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function CorrigExp(cExp)
Local aReplace	:= {}  
Local nI


aadd(aReplace, {"F1_", "SF1->F1_", "SF1->"})
aadd(aReplace, {"D1_", "SD1->D1_", "SD1->"})
aadd(aReplace, {"B1_", "SB1->B1_", "SB1->"})
aadd(aReplace, {"A1_", "SA1->A1_", "SA1->"})
aadd(aReplace, {"A2_", "SA2->A2_", "SA2->"})
aadd(aReplace, {"Z10_", "Z10->Z10_", "Z10->"})
aadd(aReplace, {"Z11_", "Z11->Z11_", "Z11->"})

aadd(aReplace, {"=", "==", "=="})
aadd(aReplace, {"<==", "<=", "<="})
aadd(aReplace, {">==", ">=", ">="})


FOR nI := 1 TO Len(aReplace)
                                                          

	cExp := Replace(cExp, aReplace[nI,1], aReplace[nI,2])
	cExp := Replace(cExp, aReplace[nI,3]+aReplace[nI,3], aReplace[nI,3])	
	
	cExp := Replace(cExp, " AND ", ".AND.")
	cExp := Replace(cExp, "..AND..", ".AND.")


	cExp := Replace(cExp, " OR ", ".OR.")
	cExp := Replace(cExp, "..OR..", ".OR.")	
Next nI
                   



Return(cExp)




  
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CP0109VL บAutor  ณAugusto Ribeiro     บ Data ณ 11/02/2011  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida Linha OK                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function CP0109VL()
Local lRet := .T.
LOcal cAux
Local oErro := ErrorBlock({|e| lRet := .f.,FilterErro(e)})


cExpr	:= alltrim(aCols[n,nZ07FILTRO])

BEGIN SEQUENCE
	cAux := &(cExpr)
End SEQUENCE

ErrorBlock(oErro)

Return(lRet)


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ FilterErro                                            ณ
//ณ Apresenta mensagem ref. a erro na expressao de Filtro ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Static Function FilterErro(e)
	If e:gencode > 0
		Help(" ",1,"FILTERR")
		//BREAK
	EndIf
Return



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ConvCFOP บAutor  ณ Augusto Ribeiro	 บ Data ณ  13/06/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Converter o CFOP                                            ฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function ConvCFOP(cCFOP)
Local cRet		:= ""
Local cCFOP1	:= ALLTRIM(U_CP01005G("11", "CONVCF1"))
Local nPosCF	:= 0
Local cCFOP2	:= ALLTRIM(U_CP01005G("11", "CONVCF2"))
Local cCFCHAR3	:= ""

IF !EMPTY(cCFOP) 
        
	cCFCHAR3	:= RIGHT(cCFOP,3)
        
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verific se a conversao e uma excecao ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	IF !EMPTY(cCFOP1)
		aCFOP1	:=  &(cCFOP1)
		
		nPosCF	:= Ascan(aCFOP1,{ |x| alltrim(x[1]) == cCFCHAR3 } )
		IF nPosCF > 0       
			cCFCHAR3	:= aCFOP1[nPosCF, 2]
		
		ELSEIF !EMPTY(cCFOP2)
			aCFOP2	:=  &(cCFOP2)
			
			nPosCF	:= Ascan(aCFOP2,{ |x| alltrim(x[1]) == cCFCHAR3 } )		
			IF nPosCF > 0       
				cCFCHAR3	:= aCFOP2[nPosCF, 2]			
			ENDIF		
		ENDIF		
	ENDIF
	     
	IF LEFT(cCFOP,1) == "5"
		cCFOP	:= "1"+cCFCHAR3
	ELSEIF LEFT(cCFOP,1) == "6"
		cCFOP	:= "2"+cCFCHAR3
	ENDIF 
	cRet	:= cCFOP
ENDIF

Return(cRet)