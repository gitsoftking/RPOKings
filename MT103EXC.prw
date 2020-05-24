#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MT103EXC � Autor � Felipe Lima de Aguiar � Data � 12/01/18 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Validacao de exclusao do documento de entrada.             ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nil => Nenhum                                              ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � l_Ret => .T. / .F.                                         ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  � Manutencao Efetuada                           ���
�������������������������������������������������������������������������Ĵ��
���              �  /  /  �                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function MT103EXC()
	
	Local a_AreaATU	:= GetArea()
	Local a_AreaSE2 := SE2->(GetArea())
    Local a_AreaZ10 := Z10->(GetArea())
	Local l_Ret 	:= .T.
	
	DbSelectArea("SE2")
	DbSetOrder(6)//E2_FILIAL, E2_FORNECE, E2_LOJA, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, R_E_C_N_O_, D_E_L_E_T_	
	//If DbSeek(xFilial("SE2") + SF1->(F1_FORNECE + F1_LOJA + F1_FILIAL + LEFT(F1_SERIE,1) + F1_DOC))
	IF DbSeek(xFilial("SE2") + SF1->(F1_FORNECE + F1_LOJA + F1_SERIE + F1_DOC))  
		While( SE2->(!Eof()) .And.((xFilial("SE2") + SF1->(F1_FORNECE + F1_LOJA + F1_SERIE + F1_DOC)) == SE2->( E2_FILIAL + E2_FORNECE + E2_LOJA + E2_PREFIXO + E2_NUM )))
						
			If !Empty(SE2->E2_DATALIB)
				l_Ret := .F.
				MsgStop("Este documento j� foi liberado para pagamento, primeiro deve-se estorna-lo para ent�o prosseguir com a exlus�o da nota fiscal."+CRLF+;
						"Favor entrar em contato com o departamento de Contabilidade.","A-T-E-N-�-�-O")
				Exit
			EndIf
		
			SE2->(DbSkip())
		EndDo
	Endif

    //Verifica se existe dado para integrar do Compila para o SE Suite
	DbSelectArea("Z10")
	Z10->(DbSetOrder(1))//Z10_FILIAL, Z10_CHVNFE, Z10_TIPARQ, R_E_C_N_O_, D_E_L_E_T_
	If Z10->(DbSeek(xFilial("Z10")+SF1->F1_CHVNFE))
		If Empty(Z10->Z10_DTSE) .And. !Empty(Z10->Z10_IDSE)
			l_Ret := .F.
			MsgStop("Favor aguardar a integra��o da classifica��o da nota no SE Suite para realizar a exclus�o.","ATENCAO") 
		EndIf
	EndIf
	
    RestArea(a_AreaZ10)
	RestArea(a_AreaSE2)
	RestArea(a_AreaATU)

Return l_Ret