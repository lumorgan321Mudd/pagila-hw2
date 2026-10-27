/*
 * Compute the total revenue for each film.
 * The output should include another new column "revenue percent" that shows the percent of total revenue that comes from the current film and all previous films.
 * That is, the "revenue percent" column is 100*"total revenue"/sum(revenue)
 *
 * HINT:
 * The `to_char` function can be used to achieve the correct formatting of your percentage.
 * See: <https://www.postgresql.org/docs/current/functions-formatting.html#FUNCTIONS-FORMATTING-EXAMPLES-TABLE>
*/
SELECT outer_total.rank, outer_total.title, outer_total.revenue, outer_total."total revenue",
TO_CHAR(100 * outer_total."total revenue" / SUM(outer_total.revenue) OVER (), 'FM900.00') AS "percent revenue" 
FROM ( 
	SELECT total_rev.rank, total_rev.title, total_rev.revenue, sum(total_rev.revenue) OVER (ORDER BY total_rev.rank) AS "total revenue"
	FROM (
        	SELECT RANK() OVER (ORDER BY revenue_films.revenue DESC) AS rank, revenue_films.title, revenue_films.revenue
        	FROM (
                	SELECT film.title, COALESCE(sum(payment.amount), 0.00) AS revenue
                	FROM film
                	LEFT JOIN inventory ON film.film_id = inventory.film_id
                	LEFT JOIN rental ON inventory.inventory_id = rental.inventory_id
                	LEFT JOIN payment ON rental.rental_id = payment.rental_id
                	GROUP BY film.title
        	) AS revenue_films
        	ORDER BY revenue_films.revenue DESC, revenue_films.title
	) AS total_rev
	ORDER BY total_rev.rank, total_rev.title
) AS outer_total
ORDER BY outer_total.revenue DESC, outer_total.title;
