/* Useful for knowing which barcoded containers are assigned to more than one location.
This report pulls information from the resources table, the components table, the instances table and the locations table. 
This report assumes access to two saved functions -- getResourceFromComponent and getTopComponent */
SELECT DISTINCT
    CONCAT(r.resourceIdentifier1,
            ' ',
            LPAD(r.resourceIdentifier2, 4, '00')) 'Collection',
    r.title 'Collection Title',
    series.subdivisionIdentifier 'Series/Accession Number',
    series.title 'Series Title',
    adi.container1Type 'Container Type',
    adi.container1NumericIndicator BoxNum,
    adi.container1AlphaNumIndicator BoxAlpha,
    adi.archDescriptionInstancesId InstanceID,
    adi.barcode Barcode,
    loc.locationId
FROM
    ArchDescriptionInstances adi
        INNER JOIN
    ResourcesComponents rc ON adi.resourceComponentId = rc.resourceComponentId
        INNER JOIN
    LocationsTable loc ON adi.locationID = loc.locationID
        INNER JOIN
    Resources r ON r.resourceId = GETRESOURCEFROMCOMPONENT(rc.resourceComponentId)
        LEFT OUTER JOIN
    ResourcesComponents series ON GETTOPCOMPONENT(rc.resourceComponentId) = series.resourceComponentID
        INNER JOIN
    (SELECT 
        barcode, locationId
    FROM
        ArchDescriptionInstances
    WHERE
        barcode <> ''
    HAVING COUNT(DISTINCT locationId) > 1) t2 ON adi.barcode = t2.barcode
