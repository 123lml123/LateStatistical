%����������
attlog.Properties.VariableNames{1} = 'id';
attlog.Properties.VariableNames{2} = 'rawData';
%ʱ�������ַ���ת��Ϊ������ʽ
rawData=datevec(attlog.rawData);
%����������
resultData(1:size(rawData,1),1)=attlog.id;
resultData(1:end,2:7)=rawData(1:end,1:6);
clear attlog rawData;
%����������
resultData=sortrows(resultData);
%ͳ��8:30֮ǰ����Ϊ��8��
resultData(1:size(resultData,1),8)=( resultData(1:end,5)==8 &  resultData(1:end,6) <= 30) | (resultData(1:end,5)<8 ) ;
%ͳ��10:00-14:30����Ϊ��9��
resultData(1:size(resultData,1),9)=( resultData(1:end,5)>=10 &  resultData(1:end,5) < 14) | (resultData(1:end,5)==14 &  resultData(1:end,6) <= 30) ;
%ͳ��16:00-19:00����Ϊ��10��
resultData(1:size(resultData,1),10)=( resultData(1:end,5)>=16 &  resultData(1:end,5) < 19) | (resultData(1:end,5)==19 &  resultData(1:end,6) == 0) ;
%ͳ��21:00֮����Ϊ��11��
resultData(1:size(resultData,1),11)= resultData(1:end,5)>=21 ;
%��ɾ�����б����Ϊ��12��
resultData(1:size(resultData,1),12)=resultData(1:size(resultData,1),8)+resultData(1:size(resultData,1),9)+resultData(1:size(resultData,1),10)+resultData(1:size(resultData,1),11);
%ͳ����ݣ�2015��3��֮ǰ����Ϊ��13��
resultData(1:size(resultData,1),13)= resultData(1:end,2)<2016 | (  resultData(1:end,2)==2016 &  resultData(1:end,3)<3 ) ;
%���ݴ����б���ɾ��������
clippedData  = obtainYearMonth( resultData );
clippedData =obtainOnTime(clippedData );
clippedData(:,8:13)=[];
%�������
%outData = clippedData(:,1);
nameId=clippedData(:,1);
day=datestr(clippedData(:,2:7),'yyyy-mm-dd');
time=datestr(clippedData(:,2:7),'HH:MM:SS');
outData=table(nameId,day,time);
%ͳ��ÿ���˵ĳٵ�����
count=histcounts(nameId)';
nameStr={'����Ա';'������';'������';'������';'��̩��';'��ǿ';'����';'��';'����';'����';'����';'������';'������';'��˹';'�˸߷�';'���ٷ�';'���Ƿ�';'������';'��˧';'����'};
countLate = table(nameStr,count,'RowNames',nameStr);
%ɨβ����
clear resultData clippedData nameId day time count nameStr;
writetable(outData,'ͳ�Ƶ���ϸ�ٵ���Ϣ.xlsx');
writetable(countLate,'ͳ�Ƶĳٵ�����.xlsx');