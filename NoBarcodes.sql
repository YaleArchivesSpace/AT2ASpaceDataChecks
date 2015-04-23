/* If you work in a repository that barcodes its boxes, this will tell you which containers don't have them stored in AT
The report pulls information from the resources table, the components table, and the instances table. 
This report assumes access to two saved functions -- getResourceFromComponent and getTopComponent */
SELECT 
    CONCAT(r.resourceIdentifier1,
            ' ',
            LPAD(r.resourceIdentifier2, 4, '00')) 'Collection',
    r.title 'Collection Title',
    series.subdivisionIdentifier 'Series/Accession Number',
    series.title 'Series Title',
    adi.container1NumericIndicator BoxNum,
    adi.container1AlphaNumIndicator BoxAlpha,
    adi.barcode,
    adi.archDescriptionInstancesId InstanceID
FROM
    ArchDescriptionInstances adi
        INNER JOIN
    ResourcesComponents rc ON adi.resourceComponentId = rc.resourceComponentId
        INNER JOIN
    Resources r ON r.resourceId = GETRESOURCEFROMCOMPONENT(rc.resourceComponentId)
        LEFT OUTER JOIN
    ResourcesComponents series ON GETTOPCOMPONENT(rc.resourceComponentId) = series.resourceComponentID
WHERE
    adi.barcode = ''
GROUP BY 'Collection' , 'Series/Accession Number' , BoxNum, BoxAlpha
