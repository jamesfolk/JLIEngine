function test(v)
    v:setValue(123.0, 456.0, 789.0)
    --print(v);
end

function btVector3Example()
    local x = 1.0;
    
    local v = bullet.btVector3(x, 2.2, 3.3);
    test(v)
    --print(v:getX(), v:getY(), v:getZ());
    
    local v2 = bullet.btVector3(1, 2, 3);
    local v3 = bullet.btVector3(v2)
    v2:setValue(123.0, 456.0, 789.0)
    print(v3)
    print(v2)
    
    
    
    
    --v:setValue(123.0, 456.0, 789.0)
    --print(v:getX(), v:getY(), v:getZ());
    
    --if(v == v2) then
    --    print "equals"
    --    print(v:x(), v:y(), v:z());
    --    print(v2:x(), v2:y(), v2:z());
    --else
    --    print "not equals"
    --    print(v:x(), v:y(), v:z());
    --    print(v2:x(), v2:y(), v2:z());
    --end
end