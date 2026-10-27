/*
 * Compute the total revenue for each film.
 * The output should include another new column "total revenue" that shows the sum of all the revenue of all previous films.
 *
 * HINT:
 * My solution starts with the solution to problem 16 as a subquery.
 * Then I combine the SUM function with the OVER keyword to create a window function that computes the total.
 * You might find the following stackoverflow answer useful for figuring out the syntax:
 * <https://stackoverflow.com/a/5700744>.
 */

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
ORDER BY total_rev.rank, total_rev.title;

