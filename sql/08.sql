/*
 * Select the title of all 'G' rated movies that have the 'Trailers' special feature.
 * Order the results alphabetically.
 *
 * HINT:
 * Use `unnest(special_features)` in a subquery.
 */

SELECT film.title
FROM film
WHERE film.rating = 'G' AND
'Trailers' IN (
	SELECT unnest(film.special_features)
)
ORDER BY film.title;
