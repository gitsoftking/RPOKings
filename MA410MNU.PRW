#Include "Protheus.Ch"
#Include "Rwmake.Ch"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA410MNU  �Autor  �Microsiga           � Data �  10/04/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � O ponto de entrada adiciona botoes no arotina do PV        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/

User function MA410MNU()   
Local lImpNFE := GetMv("MV_XMLIMP",.F.,.F.)    
    

//������������������������������������������
//� Utiliza sistema de importacao de XML ? �
//������������������������������������������
IF  lImpNFE
	aAdd(aRotina,{"Gera NF.Auto","IF (Empty(SC5->C5_NOTA),Processa({|| aRetProc := U_CP0108S(SC5->C5_NUM), IF(aRetProc[1],NIL,AVISO('Falha',aRetProc[2],{'Cancelar'},3))}, 'Gerando Nota Fiscal...'),Help( ,, 'HELP',, 'Esta nota fiscal n�o pode ser gerada, verifique o Status do Pedido.', 1, 0))", 0 , 4, 0, nil})
ENDIF 
Return()     
    
