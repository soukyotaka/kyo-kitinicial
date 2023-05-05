local Tunnel = module('vrp','lib/Tunnel')
local Proxy = module('vrp','lib/Proxy')
vRP = Proxy['getInterface']('vRP')
-- Kyo Renewed
kyocfg = {
    ['Author'] = 'Kyotaka#0007', -- developer
    ['Discord'] = 'https://discord.gg/RVPcK7sQAK', -- my server discord

    ['create database'] = false, -- no create = false or create = true

    ['Cooldown'] = {
        ['checkcooldown'] = false, -- disabled = false or enebled = true
        ['Time to cooldown'] = 900, -- time 15 minute
    },

    ['Items list'] = {
        { ['item'] = 'celular', ['amount'] = 1 }, -- phone item and quantity 1
    },

    ['vehicles'] = {
        ['Prepare'] = {
            ['Get Vehicle'] = 'SELECT veiculo FROM vrp_user_veiculos WHERE user_id = @user_id AND veiculo = @veiculo', -- change the table name if yours is different
            ['Add Vehicle'] = 'INSERT INTO vrp_user_veiculos(user_id,veiculo,ipva) VALUES(@user_id,@veiculo,@ipva)', -- change the table name if yours is different
        },

        ['Reward'] = { 
            { ['name'] = false }, -- vehicle name for example: ['name'] = 'akuma' | if you do not want to have a vehicle in your starter kit, just put it as in the example: ['name'] = false
        },
    },

    ['Menssage'] = {
        ['Already Have'] = { ['Style'] = 'negado', ['Msg'] = 'Você já possui o veiculo do kit-inicial na sua garagem.', ['Time'] = 10 }, -- message style and the message
        ['Vehicle Unavailable'] = { ['Style'] = 'negado', ['Msg'] = 'Não esta mais disponivel o veiculo do kit-inicial.', ['Time'] = 10 }, -- message style and the message
        ['Already Received'] = { ['Style'] = 'negado', ['Msg'] = 'Ops parece que você ja recebeu.', ['Time'] = 10 }, -- message style and the message
    },

    ['Function'] = {
        ['Generete'] = function(passport,item,amount)
            return vRP['giveInventoryItem'](passport,item,amount,true) -- function to generate the item
        end,

        ['Prepare'] = function(name, prepare)
            return vRP['prepare'](name,prepare) -- prepare function
        end,

        ['Query'] = function(query, result)
            return vRP['query'](query,result) -- query function
        end,

        ['Execute'] = function(name, execute)
            return vRP['execute'](name,execute) -- execute function
        end,

        ['Passport'] = function(source)
            return vRP['getUserId'](source) -- function to get the player id
        end,

        ['Notify'] = function(source,style,message,time)
            return TriggerClientEvent('Notify', source, style,message,time) -- notification function
        end,
    },
}