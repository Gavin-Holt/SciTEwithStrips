for i=1,5050 do
    if pcall(scite.ConstantName,i) then
        _G[scite.ConstantName(i)]=tonumber(i)
    end
end
