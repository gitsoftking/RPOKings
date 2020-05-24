#Include "Protheus.Ch"
#Include "rwmake.Ch"
#Include "TopConn.Ch"
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "FWMBROWSE.CH"    

#DEFINE D_ROTINA 'CP01TICTE' 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CP01TICTE บAutor  ณ Thiago Nascimento บ Data ณ  03/02/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Browser Modelo 2 MVC, para manuten็ใo das faturas de CTE   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function CP01TICTE()

Private oBrowse2
Private aRotina := {}					    
		    				    
ADD OPTION aRotina TITLE 'Pesquisar'  ACTION 'PesqBrw'           OPERATION 1 ACCESS 0
ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.'+D_ROTINA OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Incluir'	  ACTION 'VIEWDEF.'+D_ROTINA OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.'+D_ROTINA OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.'+D_ROTINA OPERATION 5 ACCESS 0				    

// Comandos para chamar novo Modelo do Objeto
			NEW MODEL ; 
			TYPE              2    ; 
			DESCRIPTION       'Manute็ใo Fatura CTE' ; 
			BROWSE            oBrowse2          ; 
			SOURCE            'CP01TICTE'    ; 
			MODELID           'Z14MODEL'      ; 
			MASTER            'Z14'            ;
			DETAIL            'Z14'            ;	
			HEADER            { 'Z14_CHVCTE', 'Z14_TIPARQ', 'Z14_VLRCTE' ,'Z14_CHVNFE'} ;  
			FILTER 			  "Z14_CHVCTE=='"+ Z10->Z10_CHVNFE +"'";
			AFTERLINE  		  { |oModelGrid,nLine| VLDLINE(oModelGrid, nLine) } ;
			AFTER			  { |oModel| VLDTOK(oModel) } ;
			PRIMARYKEY 		  {'Z14_FILIAL','Z14_CHVCTE','Z14_TIPARQ','Z14_ITEM'};
			RELATION          { { 'Z14_FILIAL', 'xFilial( "Z14" )' } , ;
			{ 'Z14_CHVCTE', 'Z14_CHVCTE' }, { 'Z14_TIPARQ', 'Z14_TIPARQ' } } ; 
			ORDERKEY          Z14->( IndexKey( 1 ) )  ;
			UNIQUELINE        { 'Z14_ITEM' } ;
			AUTOINCREMENT     'Z14_ITEM'
			
Return(NIL)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VLDTOK บAutor  ณ Thiago Nascimento	 บ Data ณ  03/02/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida็ใo do Tudo Ok										  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function VLDTOK(oModel)

Local oView 	 := FwViewActive()	
Local lRet		 := .T.
Local nTotLin	 := 0
Local nOperation := oModel:GetOperation()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
// Valido apenas inclusใo e altera็ใo   ณ		
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
IF nOperation == 3 .OR. nOperation == 4
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	// Fecha a VIEW APำS COMMITณ		
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 
	oView:SetCloseOnOk({||.T.})
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	// FOR para coleta do valor total do gridณ		
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 
	FOR nX := 1 TO LEN( OMODEL:AALLSUBMODELS[2]:ACOLS )
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		// VALIDAวรO Sำ OCORRE SE A LINHA NรO ESTIVER DELETADA ณ		
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 
		IF ! OMODEL:AALLSUBMODELS[2]:ACOLS[nX][6]	
			nTotLin +=   OMODEL:AALLSUBMODELS[2]:ACOLS[nX][5]	
		ENDIF
			
	NEXT nX	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	// Valido o total do GRID com Total XML	 ณ		
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
	IF nToTlin <> Z10->Z10_VLRTOT
		Help(" ",1,"VLDLINE",,"A soma das parcelas nใo confere com o valor com valor total do XML ",4,5)
		lRet := .F.
	ENDIF 

ENDIF		

Return(lRet)	

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VLDLINE บAutor  ณ Thiago Nascimento	 บ Data ณ  03/02/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida็ใo da Linha									      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function VLDLINE(oModelGrid, nLine)

Local lRet  	 := .T.
Local nTotLin 	 := 0 
Local oModel 	 := oModelGrid:GetModel()
Local nOperation := oModel:GetOperation()
Local nZ14Atu,nX,nRest

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
// Valido apenas inclusใo e altera็ใo   ณ		
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
IF nOperation == 3 .OR. nOperation == 4

	nZ14Atu := oModelGrid:GetLine()
	
	IF oModelGrid:GetValue('Z14_VALOR') > Z10->Z10_VLRTOT 
		Help(" ",1,"VLDLINE",,"O valor informado nใo confere com valor total do XML",4,5)
		lRet := .F.
	
	ELSE
	
		oModelGrid:GoLine( 1 )
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		// FOR para coleta do valor total do gridณ		
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		FOR nX := 1 TO oModelGrid:Length()
			
				oModelGrid:GoLine( nX )
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				// VALIDAวรO Sำ OCORRE SE A LINHA NรO ESTIVER DELETADA ณ		
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 		
				IF !(oModelGrid:IsDeleted())	
					nTotLin +=   oModelGrid:GetValue('Z14_VALOR')
				ENDIF
			
		NEXT nX	
		
		nRest := Z10->Z10_VLRTOT - nTotLin
		
		oModelGrid:GoLine( nZ14Atu )
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		// nRest negativo == Valores da           ณ
		// parcela nใo confererm com valor do CTE ณ		
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
		IF nRest < 0 
		
				IF !(oModelGrid:IsDeleted()) 
						
						lVldAlgo := .T.
						Help(" ",1,"VLDLINE",,"A soma das parcelas nใo confere com o valor com valor total do XML ",4,5)						
						lRet := .F.
				ENDIF
		
		ENDIF
			
	ENDIF

ENDIF	

Return(lRet)