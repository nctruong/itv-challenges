Solution
------------
Using message queue for updating number of page view.

We can create a page_views table to store data with: 

- `controller` 

- `action`

- `count` column to store number of page view

It depends how we want to define. It's can be just `path` and `count`. But I think the first one is more better for searching.

Because it's just a statistic so we can use `page_count` queue to store updating process. The updating process of page view would be enqueued every time users visit the page - using controller callback to enqueue message.

However, if we also can use background processing using sidekiq or delayed_job to make it. It depends on whether the system is complex or not. 