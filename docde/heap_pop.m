function [hp,hpind,minval,minind] = heap_pop(hp,hpind)
%pop min value in heap
if length(hp)==0
    disp('empty heap, no pop operation')
    return;
end
l = length(hp);
minval = hp(1);
minind = hpind(1);
hp(1) = hp(l);
hpind(1) = hpind(l);
l = l-1;
hp = hp(1:l);
hpind = hpind(1:l);


curnode = 1;
halfl = fix(l/2);
while (curnode<=halfl)
    sonnode1 = curnode*2;
    sonnode2 = sonnode1 +1;
    val1 = hp(curnode);
    val2 = hp(sonnode1);
    if l>=sonnode2
        val3 = hp(sonnode2);
    else
        val3 = inf;
    end
    if val1>val2
        if val2>val3
            %1>2>3,move3
            stat=3;
        else
            %1>2,3>2,  move 2
            stat =2;
        end
    else
        if val1>val3
            %2>1>3  move 3
            stat = 3;
        else
            %2>1,3>1, stop
            stat = 0;
        end
    end
    if (stat==0)
        break;
    elseif (stat==3)
        %swap value,1<->3
        hp(sonnode2) = val1;
        hp(curnode) = val3;
        %swap heapind
        tmp = hpind(curnode);
        hpind(curnode) = hpind(sonnode2);
        hpind(sonnode2) = tmp;
        curnode = sonnode2;
    else % stat==2
        %swap value,1<->2
        hp(sonnode1) = val1;
        hp(curnode) = val2;
        %swap heapind
        tmp = hpind(curnode);
        hpind(curnode) = hpind(sonnode1);
        hpind(sonnode1) = tmp;
        curnode = sonnode1;
    end
end




