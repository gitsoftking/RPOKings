#Include "Protheus.Ch"
#Include "rwmake.Ch"
#Include "TopConn.Ch"
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "FWMBROWSE.CH"    

#DEFINE D_ROTINA 'CP01TICTE' 

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CP01TICTE �Autor  � Thiago Nascimento � Data �  03/02/2014 ���
�������������������������������������������������������������������������͹��
���Desc.     � Browser Modelo 2 MVC, para manuten��o das faturas de CTE   ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
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
			DESCRIPTION       'Manute��o Fatura CTE' ; 
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

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � VLDTOK �Autor  � Thiago Nascimento	 � Data �  03/02/2014 ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida��o do Tudo Ok										  ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function VLDTOK(oModel)

Local oView 	 := FwViewActive()	
Local lRet		 := .T.
Local nTotLin	 := 0
Local nOperation := oModel:GetOperation()

//��������������������������������������Ŀ
// Valido apenas inclus�o e altera��o   �		
//����������������������������������������
IF nOperation == 3 .OR. nOperation == 4
	
	//������������������������Ŀ
	// Fecha a VIEW AP�S COMMIT�		
	//�������������������������� 
	oView:SetCloseOnOk({||.T.})
	
	//��������������������������������������Ŀ
	// FOR para coleta do valor total do grid�		
	//���������������������������������������� 
	FOR nX := 1 TO LEN( OMODEL:AALLSUBMODELS[2]:ACOLS )
		
		//����������������������������������������������������Ŀ
		// VALIDA��O S� OCORRE SE A LINHA N�O ESTIVER DELETADA �		
		//������������������������������������������������������ 
		IF ! OMODEL:AALLSUBMODELS[2]:ACOLS[nX][6]	
			nTotLin +=   OMODEL:AALLSUBMODELS[2]:ACOLS[nX][5]	
		ENDIF
			
	NEXT nX	
	
	//��������������������������������������Ŀ
	// Valido o total do GRID com Total XML	 �		
	//����������������������������������������	
	IF nToTlin <> Z10->Z10_VLRTOT
		Help(" ",1,"VLDLINE",,"A soma das parcelas n�o confere com o valor com valor total do XML ",4,5)
		lRet := .F.
	ENDIF 

ENDIF		

Return(lRet)	

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � VLDLINE �Autor  � Thiago Nascimento	 � Data �  03/02/2014 ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida��o da Linha									      ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function VLDLINE(oModelGrid, nLine)

Local lRet  	 := .T.
Local nTotLin 	 := 0 
Local oModel 	 := oModelGrid:GetModel()
Local nOperation := oModel:GetOperation()
Local nZ14Atu,nX,nRest

//��������������������������������������Ŀ
// Valido apenas inclus�o e altera��o   �		
//����������������������������������������	
IF nOperation == 3 .OR. nOperation == 4

	nZ14Atu := oModelGrid:GetLine()
	
	IF oModelGrid:GetValue('Z14_VALOR') > Z10->Z10_VLRTOT 
		Help(" ",1,"VLDLINE",,"O valor informado n�o confere com valor total do XML",4,5)
		lRet := .F.
	
	ELSE
	
		oModelGrid:GoLine( 1 )
		
		//��������������������������������������Ŀ
		// FOR para coleta do valor total do grid�		
		//����������������������������������������
		FOR nX := 1 TO oModelGrid:Length()
			
				oModelGrid:GoLine( nX )
				
				//����������������������������������������������������Ŀ
				// VALIDA��O S� OCORRE SE A LINHA N�O ESTIVER DELETADA �		
				//������������������������������������������������������ 		
				IF !(oModelGrid:IsDeleted())	
					nTotLin +=   oModelGrid:GetValue('Z14_VALOR')
				ENDIF
			
		NEXT nX	
		
		nRest := Z10->Z10_VLRTOT - nTotLin
		
		oModelGrid:GoLine( nZ14Atu )
		
		//����������������������������������������Ŀ
		// nRest negativo == Valores da           �
		// parcela n�o confererm com valor do CTE �		
		//�����������������������������������������	
		IF nRest < 0 
		
				IF !(oModelGrid:IsDeleted()) 
						
						lVldAlgo := .T.
						Help(" ",1,"VLDLINE",,"A soma das parcelas n�o confere com o valor com valor total do XML ",4,5)						
						lRet := .F.
				ENDIF
		
		ENDIF
			
	ENDIF

ENDIF	

Return(lRet)