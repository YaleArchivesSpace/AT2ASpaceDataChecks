SELECT 
    CONCAT(r.resourceIdentifier1,
            ' ',
            LPAD(r.resourceIdentifier2, 4, '00')) 'Collection',
    r.title 'Collection Title',
    series.subdivisionIdentifier 'Series/Accession Number',
    series.title 'Series Title',
    rc.title 'Component Title',
    rc.dateExpression 'Component Date',
    rc.extentNumber 'Number',
    rc.extentType 'Extent Type'
FROM
    ResourcesComponents rc 
        INNER JOIN
    Resources r ON r.resourceId = GETRESOURCEFROMCOMPONENT(rc.resourceComponentId)
        LEFT OUTER JOIN
    ResourcesComponents series ON GETTOPCOMPONENT(rc.resourceComponentId) = series.resourceComponentID
    where rc.extentType=''
