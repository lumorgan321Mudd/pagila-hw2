/*
 * Count the number of movies that contain each type of special feature.
 * Order the results alphabetically be the special_feature.
 */

SELECT unnest(film.special_features) as special_features, count(*) as count
FROM film
GROUP BY unnest(film.special_features)
ORDER BY unnest(film.special_features);
