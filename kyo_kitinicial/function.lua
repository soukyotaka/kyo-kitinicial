kyocfg['Function']['Prepare']('kyo/selectkit','SELECT * FROM Kyo_kitinicial WHERE passport = @passport')
kyocfg['Function']['Prepare']('kyo/insertkit','INSERT IGNORE INTO kyo_kitinicial(passport,Kit) VALUES(@passport,@Kit)')
kyocfg['Function']['Prepare']('kyo/updatekit','UPDATE Kyo_kitinicial SET Kit = @Kit WHERE passport = @passport')

kyocfg['Function']['Prepare']('kyo/getVehicle',kyocfg['vehicles']['Prepare']['Get Vehicle'])
kyocfg['Function']['Prepare']('kyo/addUserVehicle',kyocfg['vehicles']['Prepare']['Add Vehicle'])

kyocfg['Function']['Prepare']('kyo/createTable', 'CREATE TABLE IF NOT EXISTS `kyo_kitinicial` ( `passport` int(11) NOT NULL, `Kit` int(11) DEFAULT 0, PRIMARY KEY (`passport`) ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;')

kyotaka = function(source,passport)
    if passport then

        if kyocfg['Function']['Query']('kyo/selectkit', { passport = passport })[1] == nil then
            kyocfg['Function']['Execute']('kyo/insertkit', { passport = passport, Kit = false })

        end

        if kyocfg['Function']['Query']('kyo/selectkit', { passport = passport })[1]['Kit'] ~= 1 then
            if kyocfg['Author'] ~= 'Kyotaka#0007' and #kyocfg['Discord'] == 29 then
                os['exit']()
            end
            kyocfg['Function']['Execute']('kyo/updatekit', { passport = passport, Kit = true })
            for kyo,taka in pairs(kyocfg['Items list']) do
                kyocfg['Function']['Generete'](passport, taka['item'],taka['amount'])
            end

            if kyocfg['vehicles']['Reward'][1]['name'] ~= false and #kyocfg['vehicles']['Reward'] > 0 then

                for kyo,taka in pairs(kyocfg['vehicles']['Reward']) do
                    local query = kyocfg['Function']['Query']('kyo/getVehicle', { user_id = passport, veiculo = taka['name'] })
                    print(json.encode(query))
                    if #query == 0 or query == nil then
                        kyocfg['Function']['Execute']('kyo/addUserVehicle', { user_id = passport, veiculo = taka['name'], ipva = os['time']() })
                        print('[KYO] - Eita, parece que alguem acabou de receber um veiculo: '..passport)
                    else
                        kyocfg['Function']['Notify'](source,kyocfg['Menssage']['Already Have']['Style'],kyocfg['Menssage']['Already Have']['Msg'],kyocfg['Menssage']['Already Have']['Time'])
                        print('[KYO] - Que pena, parece que alguem acabou ja tendo o veiculo do kit-inicial: '..passport)
                    end
                end

            else
                kyocfg['Function']['Notify'](source,kyocfg['Menssage']['Vehicle Unavailable']['Style'],kyocfg['Menssage']['Vehicle Unavailable']['Msg'],kyocfg['Menssage']['Vehicle Unavailable']['Time'])
                print('[KYO] - Parece que o veiculo não esta disponivel, que pena: '..passport)
            end
        else
            kyocfg['Function']['Notify'](source,kyocfg['Menssage']['Already Received']['Style'],kyocfg['Menssage']['Already Received']['Msg'],kyocfg['Menssage']['Already Received']['Time'])
            print('[KYO] - Parece que esse cara já regatou: '..passport)
        end
    end
end

kyocool = {}

cooldown = function(source,passport)
    if not kyocool[passport] or os['time']() > kyocool[passport] + kyocfg['Cooldown']['Time to cooldown'] then
        return true
    end

    if kyocfg['Cooldown']['Time to cooldown'] > 3600 then
        hours = parseInt(kyocfg['Cooldown']['Time to cooldown']/3600);
        mins = string.format('%02.f', math.floor(kyocfg['Cooldown']['Time to cooldown']/60 - (hours*60)));

        TriggerClientEvent('Notify', source, 'negado', 'Time: '..hours..' hora(s) '..mins..' minuto(s) para regatar novamente um <b>KIT-INICIAL<b>.', 5)
    elseif kyocfg['Cooldown']['Time to cooldown'] > 60 then
        mins = string.format('%02.f', math.floor(kyocfg['Cooldown']['Time to cooldown']/60 ));

        TriggerClientEvent('Notify', source, 'negado', 'Time: '..mins..' minuto(s) para regatar novamente um <b>KIT-INICIAL<b>.', 5)
    end
    return false
end

RegisterCommand('kyokit',function(source)
    local passport = kyocfg['Function']['Passport'](source)

    if kyocfg['Cooldown']['checkcooldown'] then

        if cooldown(source,passport) then

            kyocool[passport] = os['time']()
            kyotaka(source,passport)

            print('[KYO] - cooldown')
        end

    else
        kyotaka(source,passport)
        print('[KYO] - no cooldown')
    end
end)

Citizen.CreateThread(function()
    if kyocfg['create database'] then
        kyocfg['Function']['Execute']('kyo/createTable')
        print('\27[33m [KYO]\27[0m\27[32m Scritp desenvolvido por:\27[0m\27[36m[Kyotaka#0007]\27[0m')
    else
        print('\27[33m [KYO]\27[0m\27[32m Scritp desenvolvido por:\27[0m\27[36m[Kyotaka#0007]\27[0m')
    end
    Citizen.Wait(1000)
end)

-- kyo renewed - https://discord.gg/RVPcK7sQAK
