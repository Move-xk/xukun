clc
clear



% data = load('D:\Workfile\20231103 RD200注册文档第二期\YF-RD200-078_系统硬件设计开发验证报告\数据\A.txt');
% data = load('D:\Workfile\20231225 自研相机滤波测试\kj_up.txt');
data=[];
%  data = load('D:\Workfile\20231103 王marker\10.txt');
data = [data; load('D:\Workfile\20240124 超声骨刀精度重复性测试\重复安装精度数据\刀尖向左\安装第一次\marker_pose.txt')];
% data = [data; load('D:\Workfile\20240124 超声骨刀精度重复性测试\重复安装精度数据\刀尖向左\安装第二次\marker_pose.txt')];
% data = [data; load('D:\Workfile\20240124 超声骨刀精度重复性测试\重复安装精度数据\刀尖向左\安装第三次\marker_pose.txt')];
% data = [data; load('D:\Workfile\20240124 超声骨刀精度重复性测试\重复安装精度数据\刀尖向左\安装第四次\marker_pose.txt')];
% data = [data; load('D:\Workfile\20240124 超声骨刀精度重复性测试\重复安装精度数据\刀尖向左\安装第五次\marker_pose.txt')];
% data = [data; load('D:\Workfile\20240124 超声骨刀精度重复性测试\重复安装精度数据\刀尖向左\安装第六次\marker_pose.txt')];
% data = [data; load('D:\Workfile\20240124 超声骨刀精度重复性测试\重复安装精度数据\刀尖向左\安装第七次\marker_pose.txt')];
% data = [data; load('D:\Workfile\20240124 超声骨刀精度重复性测试\重复安装精度数据\刀尖向左\安装第八次\marker_pose.txt')];
% data = [data; load('D:\Workfile\20240124 超声骨刀精度重复性测试\重复安装精度数据\刀尖向左\安装第九次\marker_pose.txt')];
% data = [data; load('D:\Workfile\20240124 超声骨刀精度重复性测试\重复安装精度数据\刀尖向左\安装第十次\marker_pose.txt')];



% data = [data; load('D:\Workfile\20240124 超声骨刀精度重复性测试\Marker 精度对比\第一次\marker_pose.txt')];
% data = [data; load('D:\Workfile\20240124 超声骨刀精度重复性测试\Marker 精度对比\第二次\marker_pose.txt')];
% data = [data; load('D:\Workfile\20240124 超声骨刀精度重复性测试\Marker 精度对比\第三次\marker_pose.txt')];
% data = [data; load('D:\Workfile\20240124 超声骨刀精度重复性测试\Marker 精度对比\第四次\marker_pose.txt')];
% data = [data; load('D:\Workfile\20240124 超声骨刀精度重复性测试\Marker 精度对比\第五次\marker_pose.txt')];
% data = [data; load('D:\Workfile\20240124 超声骨刀精度重复性测试\Marker 精度对比\第六次\marker_pose.txt')];
% data = [data; load('D:\Workfile\20240124 超声骨刀精度重复性测试\Marker 精度对比\第七次\marker_pose.txt')];
% data = [data; load('D:\Workfile\20240124 超声骨刀精度重复性测试\Marker 精度对比\第八次\marker_pose.txt')];
% data = [data; load('D:\Workfile\20240124 超声骨刀精度重复性测试\Marker 精度对比\第九次\marker_pose.txt')];
% data = [data; load('D:\Workfile\20240124 超声骨刀精度重复性测试\Marker 精度对比\第十次\marker_pose.txt')];

 
 
%% 
% pos_tip = data(:,1:3);
% ori_tip = data(:,4:6);
% pos_base = data(:,7:9);
% ori_base = data(:,10:12);

%% 自研相机-视觉脚本 位置x y z 姿态x y z w
pos_tip= data(:,1:3);
ori_tip(:,1)= data(:,7);
ori_tip(:,2:4)= data(:,4:6);

pos_base = data(:,8:10);
ori_base(:,1)= data(:,14);
ori_base(:,2:4)= data(:,11:13);

%% Tracker采集工具 位置x y z 姿态r p y
% pos_base = data(:,2:4);
% ori_base(:,1) = data(:,7);
% ori_base(:,2) = data(:,6);
% ori_base(:,3) = data(:,5);
% pos_tip = data(:,8:10);
% ori_tip(:,1) = data(:,13);
% ori_tip(:,2) = data(:,12);
% ori_tip(:,3) = data(:,11);

%% 电子面弓采集
% pos_base = data(:,3:5);
% ori_base = data(:,6:9);
% 
% pos_tip = data(:,8:10);
% ori_tip = data(:,11:13);
% 

 num = size(data,1);

for i=1:num
    
        %四元数转旋转矩阵
        ori_tip_m = quat2rotm(ori_tip(i,:));
        ori_base_m = quat2rotm(ori_base(i,:));
         
        %zyx欧拉角转旋转矩阵
%         ori_tip_m = eul2rotm(ori_tip(i,:),'zyx');
%         ori_base_m = eul2rotm(ori_base(i,:),'zyx');
        %轴角转旋转矩阵
%         ori_tip_m = rotationVectorToMatrix(ori_tip(i,:))';
%         ori_base_m = rotationVectorToMatrix(ori_base(i,:))';
        
        
% % %         
        
        tip = [ori_tip_m pos_tip(i,:)';0 0 0 1];
        base = [ori_base_m pos_base(i,:)';0 0 0 1];
        
%坐标变换
% 
% tcp = inv(tip)*base;   % tip和base在打印txt的时候反了，就翻一下

%         tcp = inv(base)*tip;   %正常情况 tip在base下
%         tcp = tip;
        tcp = base;
 


    
    
        Xx(i) = tcp(1,1);        Xy(i) = tcp(2,1);           Xz(i) = tcp(3,1);        
        Yx(i) = tcp(1,2);        Yy(i) = tcp(2,2);           Yz(i) = tcp(3,2); 
        Zx(i) = tcp(1,3);        Zy(i) = tcp(2,3);           Zz(i) = tcp(3,3); 
% %     z = [ tcp(1,3), tcp(2,3),tcp(3,3)];
% %     y = cross(z,[1,0 ,0]);
% %     y = y./norm(y);
% %     x = cross(y,z);
% %     
%         Xx(i) = x(1);        Xy(i) = x(2);           Xz(i) = x(3);        
%         Yx(i) = y(1);        Yy(i) = y(2);           Yz(i) = y(3); 
%         Zx(i) = z(1);        Zy(i) = z(2);           Zz(i) = z(3); 

        
        X(i) = tcp(1,4);         Y(i) = tcp(2,4);         Z(i) = tcp(3,4); 
        
       ori_data = [ Xx(i),Yx(i),Zx(i);            Xy(i),Yy(i),Zy(i);            Xz(i),Yz(i),Zz(i)];
                
        ori(i,:) = rotm2quat(ori_data);   
        pos(i,:) = [X(i);Y(i);Z(i)];
        ori_eul(i,:) = rotm2eul(ori_data);
%         pos_rot(i,:)=rad2deg(rotationMatrixToVector(ori_data));   
%         oo1(i,:) = [Xx(i);Xy(i);Xz(i)];
%          oo2(i,:) = [Yx(i);Yy(i);Yz(i)];
%           oo3(i,:) = [Zx(i);Zy(i);Zz(i)];
        
end


%%求最小球包络
x = pos(:,1);
y = pos(:,2);
z = pos(:,3);
num = size(x,1);
[sphereCenter, radius] = min_enclosing_sphere(x, y, z, num);
ac=sphereCenter;
figure(1)
clf
draw_sphere(sphereCenter, radius)
hold on
grid on
plot3(x, y, z, 'r+')
plot3(sphereCenter(1),sphereCenter(2),sphereCenter(3),'bo')
txt = ['R' num2cell(radius) '(mm)'];
text(sphereCenter(1)+radius,sphereCenter(2),sphereCenter(3),txt,'FontSize',20)
axis equal tight
if sum(sqrt((x - sphereCenter(1)).^2 + (y - sphereCenter(2)).^2 + (z - sphereCenter(3)).^2) > radius + 0.0001) > 0
   disp('至少有一个点在球面以外')
end

%%求最小姿态夹角
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
% RR=norm(avg_pos);
% RR=150;
% tip_error = max_diff_angle*pi*RR/180;
% arr=[max_diff_angle RR tip_error]

%画姿态图
DisplayTcpOri(6,zeros(size(X)),zeros(size(X)),zeros(size(X)),Xx,Xy,Xz,Yx,Yy,Yz,Zx,Zy,Zz,1,1)
% DisplayTcpOri(6,X,Y,Z,Xx,Xy,Xz,Yx,Yy,Yz,Zx,Zy,Zz,1,1)


txt = ['max angle' num2cell(max_diff_angle) '（deg)'];
text(0,0,0,txt,'FontSize',20)

ori_diff_with_avg=[];
pos_diff_with_avg=[];
avg_all=[avg_ori,avg_pos];
for i=1:num
    ori_diff_with_avg(i) = abs(acosd(abs(dot(ori(i,:), avg_ori))));
    pos_diff_with_avg(i) = norm(avg_pos-pos(i,:));
end

%% 画统计直方图
figure(3)
clf
hold on
grid on
yyaxis left
histogram(pos_diff_with_avg, 'Normalization', 'probability')
yyaxis right
histogram(ori_diff_with_avg, 'Normalization', 'probability')
legend('位置误差','姿态误差')

arr=[radius std(pos) norm(std(pos)) std(ori_eul) norm(std(ori_eul))  max_diff_angle  ];
