function [Ocean_Depth_at_Receiver] = GetReceiverDepth (nav,header,ElementNum)

    Depth_Data = [nav.vesselX;nav.vesselY;nav.depth];
    receivernum1 = header.channelSet1Channels;
    x_r_utc1 = zeros(1,receivernum1); y_r_utc1 = zeros(1,receivernum1);
    X_Airgun = nav.sourceX(header.fileNumber); 
    Y_Airgun = nav.sourceY(header.fileNumber);

    if sqrt((X_Airgun-nav.receiverX(112,header.fileNumber))^2+(Y_Airgun-nav.receiverY(112,header.fileNumber))^2) < sqrt((X_Airgun-nav.receiverX(111,header.fileNumber))^2+(Y_Airgun-nav.receiverY(111,header.fileNumber))^2)     
        X_R1(ElementNum) = nav.receiverX(ElementNum,header.fileNumber);
        Y_R1(ElementNum) = nav.receiverY(ElementNum,header.fileNumber);
    else
        X_R1(ElementNum) = nav.receiverX(receivernum1-ElementNum+1,header.fileNumber);
        Y_R1(ElementNum) = nav.receiverY(receivernum1-ElementNum+1,header.fileNumber);
    end

    d = sqrt((X_R1(ElementNum)-Depth_Data(1,:)).^2+(Y_R1(ElementNum)-Depth_Data(2,:)).^2);
    [value_min, index_min] = min(d);
    if value_min <= 240
        Ocean_Depth_at_Receiver = Depth_Data(3,index_min);
    else
        Ocean_Depth_at_Receiver = NAN;
    end
end

