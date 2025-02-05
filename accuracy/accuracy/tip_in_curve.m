clc
clear

%% 上下牙marker在相机下的
% data1 = load('D:\Workfile\20230614 二维码精度验证\x_x_code_A002_CameraMoving.txt');
% data2 = load('D:\Workfile\20230614 二维码精度验证\x_x_code_TB002_CameraMoving.txt');
% 
% 
% ind1_temp=data1(:,1);
% pos_tip_temp = data1(:,2:4);
% ori_tip_temp = data1(:,5:8);
% ind2_temp=data2(:,1);
% pos_curve_temp = data2(:,2:4);
% ori_curve_temp = data2(:,5:8);
% 
% num = size(pos_tip_temp,1);
% 
% pos_tip=[];
% ori_tip=[];
% pos_curve=[];
% ori_curve=[];
% index=[];
% ind1=[];ind2=[];
% for i=1:num
%     for j=1:num
%         if ind1_temp(i)>ind2_temp(j)
%             continue
%         elseif ind1_temp(i)==ind2_temp(j)
%             pos_tip = [pos_tip; pos_tip_temp(i,:)];
%             ori_tip = [ori_tip; ori_tip_temp(i,:)];
%             pos_curve = [pos_curve; pos_curve_temp(j,:)];
%             ori_curve = [ori_curve; ori_curve_temp(j,:)];
%             
%             ind1=[ind1;ind1_temp(i)];
%              ind2=[ind2;ind2_temp(j)];
%             index=[index;i];
%         end
%     end
% end



% data = load('D:\Workfile\20230614 二维码精度验证\pingmian_points.txt');
% data = load('D:\data\marker_pose.txt');
% data=load('D:\Workfile\20230614 二维码精度验证\20230704 滤波掉重建误差大的值\双平面.txt');

% data = load('D:\Workfile\20230614 二维码精度验证\20230703\双平面-动态.txt');

% data([108,796],:)=[];
% stat=4;
% pos_tip = data(:,1:3);
% ori_tip = data(:,4:7);

% pos_tip = data(:,12:14);
% ori_tip = data(:,8:11);

% pos_tip = data(:,5:7);
% ori_tip = data(:,1:4);





% pos_curve = data(:,8:10);
% ori_curve = data(:,11:14);



% data1 = load('D:\Workfile\20230614 二维码精度验证\曲面marker和钻头标定板230626\xcode.txt');
% data2 = load('D:\Workfile\20230614 二维码精度验证\曲面marker和钻头标定板230626\钻头标定板.txt');
% t
% pos_tip = data1(:,1:3);
% ori_tip = data1(:,4:7);
% pos_curve = data2(:,1:3);
% ori_curve = data2(:,4:7);

data = load('D:\data\x_x_code_TB001_change.txt');
% pos_tip = data(:,1:3);
% ori_tip = data(:,4:7);
% pos_curve = data(:,8:10);
% ori_curve = data(:,11:14);

% pos_tip = data(:,8:10);
% ori_tip = data(:,11:14);
pos_curve = data(:,2:4);
ori_curve = data(:,5:8);

 num = size(pos_curve,1);

% 
% 
% pos_diff = pos_tip-pos_curve;
% pos_diff_norm = sqrt(pos_diff(:,1).^2+pos_diff(:,2).^2+pos_diff(:,3).^2);



for i=1:num
    

    
%         ori_tip_m = quat2dcm(ori_tip(i,:))';
        ori_curve_m = quat2dcm(ori_curve(i,:))';
        
%         tip = [ori_tip_m pos_tip(i,:)';0 0 0 1];
        curve = [ori_curve_m pos_curve(i,:)';0 0 0 1];
        
%         tool=[eye(3) [0;0;133];0,0,0,1];
%         tcp = inv(tip)*curve;
%         tcp = inv(curve)*tip;   
%         tcp = curve*tool;
%         tcp = tip;
 tcp = curve;
 
        Xx(i) = tcp(1,1);        Xy(i) = tcp(2,1);           Xz(i) = tcp(3,1);        

        Yx(i) = tcp(1,2);        Yy(i) = tcp(2,2);           Yz(i) = tcp(3,2); 

        Zx(i) = tcp(1,3);        Zy(i) = tcp(2,3);           Zz(i) = tcp(3,3); 

        X(i) = tcp(1,4); 
        Y(i) = tcp(2,4); 
        Z(i) = tcp(3,4); 
        
       ori_data = [ Xx(i),Yx(i),Zx(i);
            Xy(i),Yy(i),Zy(i);
            Xz(i),Yz(i),Zz(i)];
                
        ori(i,:) = dcm2quat(ori_data);   
        pos(i,:) = [X(i);Y(i);Z(i)];
        oo1(i,:) = [Xx(i);Xy(i);Xz(i)];
         oo2(i,:) = [Yx(i);Yy(i);Yz(i)];
          oo3(i,:) = [Zx(i);Zy(i);Zz(i)];
        
% 
%         pos_diff = pos_tip(i,:)-pos_curve(i,:);
% pos_diff_norm(i) = norm(pos_diff);
end



% DisplayTcpOri(9,X,Y,Z,Xx,Xy,Xz,Yx,Yy,Yz,Zx,Zy,Zz,1,1)

% figure(2)
% plot(pos_diff_norm)

% max(pos_diff_norm)-min(pos_diff_norm)


main();
max_diff_angle=0;
max_pair=[];
for i=1:num
    for j=2:num
        if i==j
            continue
        end
 
         diff_angle_1 = abs(acosd(abs(dot(ori(i,:), ori(j,:)))));
         if diff_angle_1>max_diff_angle
             max_diff_angle = diff_angle_1;
             max_pair=[i,j];
         end
    end
end

avg_ori = quat_avg(ori)';
avg_pos = mean(pos);
RR=norm(avg_pos);
tip_error = max_diff_angle*pi*RR/180;
arr=[max_diff_angle RR tip_error]

% o=[0,0];
% DisplayTcpOri(8,o,o,o,Xx(max_pair),Xy(max_pair),Xz(max_pair),Yx(max_pair),Yy(max_pair),Yz(max_pair),Zx(max_pair),Zy(max_pair),Zz(max_pair),1,1)
DisplayTcpOri(6,zeros(size(X)),zeros(size(X)),zeros(size(X)),Xx,Xy,Xz,Yx,Yy,Yz,Zx,Zy,Zz,1,1)
txt = ['max angle' num2cell(max_diff_angle) '（deg)'];
text(0,0,0,txt,'FontSize',20)


ori_diff_with_avg=[];
pos_diff_with_avg=[];
avg_all=[avg_ori,avg_pos];
for i=1:num
    ori_diff_with_avg(i) = abs(acosd(abs(dot(ori(i,:), avg_ori))));
    pos_diff_with_avg(i) = norm(avg_pos-pos(i,:));
end

figure(3)
clf
hold on
yyaxis left
plot(pos_diff_with_avg)
yyaxis right
plot(ori_diff_with_avg)
legend('pos','ori')


