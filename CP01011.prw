#Include 'Protheus.ch'
#INCLUDE "TopConn.ch"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CP01011  �Autor  � Thiago Nascimento	 � Data �  24/01/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o que vincula notas especificas de entrada com as     ���
���          � suas notas de sa�das originais para utilizar na Execauto   ���
���          � da gera��o da pr�-nota, e documento de entrada			  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function CP0101X(_cFilial, _cProd, _cCliFor, _cLoja, _cNumDoC, _cSerie, _nQuant, _nPrUnit)

Local aRetPD3 := {} // Array de retorno da Fun��o
Local cQuery  := ""
Local nCount  := 0
Local lSaldo  := .F.
Local lDifVal := .T.
Local nDif

//��������������������������������������������Ŀ
//� Query que busca dados do poder de Terceiro �                         
//����������������������������������������������
cQuery := " SELECT B6_FILIAL, B6_CLIFOR, B6_DOC, B6_SERIE, B6_IDENT, B6_QUANT, B6_PRUNIT ,D2_ITEM, B6_TES " +CRLF
cQuery += " FROM " +RetSqlName("SB6")+" B6 WITH(NOLOCK) " +CRLF
cQuery += " INNER JOIN " +RetSqlName("SD2")+ " D2 WITH(NOLOCK) " +CRLF
cQuery += " ON  B6_FILIAL = D2_FILIAL " +CRLF
cQuery += " AND B6_CLIFOR = D2_CLIENTE " +CRLF
cQuery += " AND B6_DOC	  = D2_DOC " +CRLF
cQuery += " AND B6_SERIE = D2_SERIE " +CRLF
cQuery += " AND B6_PRODUTO = D2_COD " +CRLF
cQuery += " AND D2.D_E_L_E_T_ = '' " +CRLF
cQuery += " WHERE B6_FILIAL = '"+_cFilial+"' "+CRLF
cQuery += " AND B6_CLIFOR = '"+_cCliFor+"' " +CRLF
cQuery += " AND B6_LOJA = '"+_cLoja+"' " +CRLF
cQuery += " AND B6_PRODUTO = '"+_cProd+"' " +CRLF
cQuery += " AND B6_DOC = '"+ _cNumDoc+"' " +CRLF
cQuery += " AND B6_SERIE = '"+ _cSerie +"' "+CRLF
cQuery += " AND B6_UENT = '' " +CRLF
cQuery += " AND B6_SALDO > 0 " +CRLF
cQuery += " AND B6.D_E_L_E_T_ = '' " +CRLF

//���������������������������������Ŀ
//� Close na TRB caso esteja em uso �                         
//�����������������������������������
IF Select("TRBSB6") > 0
	TRBSB6->(DBCLOSEAREA())
ENDIF

dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),'TRBSB6')

DbSelectArea("TRBSB6")

TRBSB6->(DBGoTop())	
TRBSB6->( dbEval( {|| nCount++ } ) )	
TRBSB6->(DBGoTop())

IF 	nCount > 0
	
	//����������������������������������Ŀ
	//� Quando ocorrer apenas 1 registro �
	//� na TRBSB6 n�o entra no la�o      �                
	//������������������������������������
	IF nCount > 1
		
		While TRBSB6->(! EOF()) 
			
			// Valido quantidade para vincular poder de terceiro.				
			If TRBSB6->B6_QUANT >= _nQuant   
		 		
		 		IF  ROUND(TRBSB6->B6_PRUNIT,2) == _nPrUnit
					lSaldo  := .T.
					lDifVal := .F.			
					AADD(aRetPD3, .T.)
					AADD(aRetPD3 ,TRBSB6->B6_DOC   )
					AADD(aRetPD3 ,TRBSB6->B6_SERIE )
					AADD(aRetPD3, TRBSB6->D2_ITEM  )
					AADD(aRetPD3, TRBSB6->B6_IDENT )					
					AADD(aRetPD3, "Produto "+ALLTRIM(_cProd)+" vinculado ao poder de terceiro com sucesso" )
					AADD(aRetPD3, TRBSB6->B6_TES )
					EXIT
					
				ELSE					
					lDifVal := .T.	
					nDif    := ROUND(TRBSB6->B6_PRUNIT,2)						
				ENDIF
			
			ELSE
				lSaldo := .F.																	
			Endif
						
			TRBSB6->(DbSkip())
		Enddo
		
		//�����������������������������������Ŀ
		//� Caso valores estajam <> no poder  �
		//� de 3� alimento o array de retorno �                
		//�������������������������������������		
		IF	lDifVal
								
			AADD(aRetPD3, .F.)
			AADD(aRetPD3, nil )
			AADD(aRetPD3 ,nil )
			AADD(aRetPD3 ,nil )
			AADD(aRetPD3, nil )
			AADD(aRetPD3, "Produto "+ALLTRIM(_cProd)+" com pre�o divergente no poder de terceiro PD3: " ;
			+ cValToChar(nDif) + " <> XML: " + cValToChar(_nPrUnit))
		
		//�����������������������������������Ŀ
		//� Caso n�o tenha saldo no poder	  �
		//� de 3� alimento o array de retorno �                
		//�������������������������������������					
		ELSEIF ! lSaldo
		
			AADD(aRetPD3, .F.)
			AADD(aRetPD3, nil )
			AADD(aRetPD3 ,nil )
			AADD(aRetPD3 ,nil )
			AADD(aRetPD3, nil )
			AADD(aRetPD3, "Produto "+ALLTRIM(_cProd)+" com saldo insuficiente no poder de terceiro" ) 
		
		ENDIF			
	
	// Quando h� apenas 1 registro na TRBSB6	
	ELSE
			// Valido quantidade para vincular poder de terceiro aqui tamb�m
			If TRBSB6->B6_QUANT >= _nQuant   
		 		
		 		IF  ROUND(TRBSB6->B6_PRUNIT,2) == _nPrUnit
					lSaldo := .T.
					lDifVal := .F.			
					AADD(aRetPD3, .T.)
					AADD(aRetPD3 ,TRBSB6->B6_DOC   )
					AADD(aRetPD3 ,TRBSB6->B6_SERIE )
					AADD(aRetPD3, TRBSB6->D2_ITEM  )
					AADD(aRetPD3, TRBSB6->B6_IDENT )					
					AADD(aRetPD3, "Produto "+ALLTRIM(_cProd)+" vinculado ao poder de terceiro com sucesso" )	
					AADD(aRetPD3, TRBSB6->B6_TES )			
					
				ELSE					
					lDifVal := .T.	
					nDif    := ROUND(TRBSB6->B6_PRUNIT,2)						
				ENDIF
			
			ELSE
				lSaldo := .F.																	
			Endif
					
		//�����������������������������������Ŀ
		//� Caso valores estajam <> no poder  �
		//� de 3� alimento o array de retorno �                
		//�������������������������������������		
		IF	lDifVal
								
			AADD(aRetPD3, .F.)
			AADD(aRetPD3, nil )
			AADD(aRetPD3 ,nil )
			AADD(aRetPD3 ,nil )
			AADD(aRetPD3, nil )
			AADD(aRetPD3, "Produto "+ALLTRIM(_cProd)+" com pre�o divergente no poder de terceiro PD3: " ;
			+ cValToChar(nDif) + " <> XML: " + cValToChar(_nPrUnit))
		
		//�����������������������������������Ŀ
		//� Caso n�o tenha saldo no poder	  �
		//� de 3� alimento o array de retorno �                
		//�������������������������������������					
		ELSEIF ! lSaldo
		
			AADD(aRetPD3, .F.)
			AADD(aRetPD3, nil )
			AADD(aRetPD3 ,nil )
			AADD(aRetPD3 ,nil )
			AADD(aRetPD3, nil )
			AADD(aRetPD3, "Produto "+ALLTRIM(_cProd)+" com saldo insuficiente no poder de terceiro" ) 
		
		ENDIF				
		
	ENDIF

//������������������������������������Ŀ
//� Caso n�o tenha registro no poder   �
//� de 3� alimento o array de retorno  �                
//��������������������������������������
ELSE
	
	AADD(aRetPD3, .F.)
	AADD(aRetPD3, nil )
	AADD(aRetPD3, nil )
	AADD(aRetPD3, nil )
	AADD(aRetPD3, nil )
	AADD(aRetPD3, "Produto "+ALLTRIM(_cProd)+" sem registro no poder de terceiro" )
	 
ENDIF	

Return(aRetPD3)                                                                                                          