function barPLV(PLV,subjID)
% set graph size
% set(gcf,'position',[20,10,2560,1252]);

if length(PLV) == 1 %male subject
   b = bar3(PLV{1});
   for k = 1:length(b)
        zdata = get(b(k),'Zdata');
        set(b(k),'Cdata',zdata)
    end
    title(sprintf('PLV of Male %s',subjID)) 
    
else %female subject
    
    subplot(2,2,1)
    b1 = bar3(PLV{1});
    for k = 1:length(b1)
        zdata = get(b1(k),'Zdata');
        set(b1(k),'Cdata',zdata)
    end
    title('PLV of Diestrus');
    
    subplot(2,2,2)
    b2 = bar3(PLV{2});
    for k = 1:length(b2)
        zdata = get(b2(k),'Zdata');
        set(b2(k),'Cdata',zdata)
    end
    title('PLV of Proestrus');
    
    subplot(2,2,3)
    b3 = bar3(PLV{3});
    for k = 1:length(b3)
        zdata = get(b3(k),'Zdata');
        set(b3(k),'Cdata',zdata)
    end
    title('PLV of Estrus');
    
    subplot(2,2,4)
    b4 = bar3(PLV{4});
    for k = 1:length(b4)
         zdata = get(b4(k),'Zdata');
         set(b4(k),'Cdata',zdata)
    end
    title('PLV of Metestrus')
end