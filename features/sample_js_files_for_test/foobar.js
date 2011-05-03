// A Sample Test function
function Klass(definition)
{
    var prototype = definition;

    if (definition['_extends'] !== undefined)
    {
        $.each(definition['_extends'].prototype, function(k, v){

            if (prototype[k] === undefined) {
                prototype[k] = v;
            } else {
                prototype[k+'_super'] = v;
            }
        });
    }

    var constructor = definition['_init'];
    if (constructor === undefined)
    {
        constructor = function()
        {
            if (this.prototype('_init_super')) {
                this._init_super();
            }
        }
    }
    constructor.prototype = prototype;
    return constructor
}
