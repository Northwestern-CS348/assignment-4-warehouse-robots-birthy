(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
   
   (:action robotMove
        :parameters (?r -robot ?start - location ?end - location)
        :precondition (and (at ?r ?start) (free ?r) (no-robot ?end) (connected ?start ?end))
        :effect (and (no-robot ?start) (not (no-robot ?end))
                    (at ?r ?end) (not (at ?r ?start)) (free ?r))
   )
   
   (:action robotMoveWithPallette
        :parameters (?r - robot ?start - location ?end - location ?p - pallette)
        :precondition (and (at ?r ?start) (at ?p ?start) (free ?r) (connected ?start ?end)
                        (no-robot ?end) (no-pallette ?end))
        :effect (and (at ?r ?end) (at ?p ?end) (not (at ?r ?start)) (not (at ?p ?start))
                    (no-robot ?start) (no-pallette ?start) (not (no-robot ?end)) (not (no-pallette ?end)))
   )
   
   (:action moveItemFromPalletteToShipment
        :parameters (?l - location ?s - shipment ?i - saleitem ?o - order ?p - pallette)
        :precondition (and (at ?p ?l) (packing-location ?l) (packing-at ?s ?l)
                            (started ?s) (ships ?s ?o) (orders ?o ?i) (contains ?p ?i))
        :effect (and (not (contains ?p ?i)) (includes ?s ?i))
   )
   
   (:action completeShipment
        :parameters (?l - location ?s - shipment ?o - order)
        :precondition (and (packing-location ?l) (packing-at ?s ?l)
                            (started ?s) (not (complete ?s)) (ships ?s ?o))
        :effect (and (complete ?s) (available ?l) (not (packing-at ?s ?l)))
   )

)
