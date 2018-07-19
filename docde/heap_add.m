function [hp,hpind] = heap_add(hp,hpind,addval,addind)
%invind is current pos of 1:l point in hps
l = length(hp)+1;
hp(l) = addval;
hpind(l) = addind;
curnode = l;
while (curnode>1)
    parnode = fix(curnode/2);
    if hp(parnode)>hp(curnode)%FOR MIN-heaps
        %swap value
        tmp = hp(parnode);
        hp(parnode) = hp(curnode);
        hp(curnode) = tmp;
        %swap heapind
        tmp = hpind(parnode);
        hpind(parnode) = hpind(curnode);
        hpind(curnode) = tmp;
        curnode = parnode;
    else
        break;
    end
end