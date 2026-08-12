function fn(){
    karate.configure('ssl', true);
    var env = karate.env;

    if(!env){
        env='cert';
    }

    karate.log('Ambiente:', env);
    var Baseurl = '';
    var WalletUrl = '';
    var TransferUrl = ''; // <--- Agregado

    if(env == 'desa' || env == 'cert'){
        Baseurl = 'http://134.209.211.10:4001/auth/v1/'; // <--- Agregado (Puerto 4001)
        WalletUrl = 'http://134.209.211.10:4002/wallet/v1/'; // <--- Agregado (Puerto 4002)
        TransferUrl = 'http://134.209.211.10:4003/transfer/v1/'; // <--- Agregado (Puerto 4003)
    }

    var getRandomPhone = function() {
        return '9' + Math.floor(10000000 + Math.random() * 90000000);
    };

    var getRandomEmail = function(prefix) {
        return prefix + '_' + java.lang.System.currentTimeMillis() + '@test.com';
    };

    return {
        Baseurl: Baseurl,
        WalletUrl: WalletUrl,
        TransferUrl: TransferUrl, // <--- Exportado
        env: env,
        getRandomPhone: getRandomPhone,
        getRandomEmail: getRandomEmail
    };
}