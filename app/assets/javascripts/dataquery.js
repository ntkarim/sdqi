$(function() {

    $(".slider")

        .slider({
            min: 1980,
            max: 2015,
            range: true,
            values: [1990, 2000],
            step: 1,
            slide: function( event, ui ) {
                $( "#amount" ).val(ui.values[ 0 ] + "," + ui.values[ 1 ] );
            }

        })

        .slider("pips", {
            rest: "label",
            step: 5
        })
        .slider("float");

    $( "#amount" ).val($( ".slider" ).slider( "values", 0 )+","+$( ".slider" ).slider( "values", 1 ));

});