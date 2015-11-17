import web
import json

urls = (
    '/api/data/(\d*)/(\d*)', 'Data',
    '/api/dump', 'Dump',
    '/api/stats', 'Stats',
    '/', 'Index'
)

db = web.database(dbn='mysql', user='root', db='opt')
render = web.template.render('templates/')


class Dump:
    def GET(self):
        return json.dumps(list(db.select('comments')))


class Data:
    def GET(self, page_no, count):
        cnt = int(count)
        offset = cnt * int(page_no)

        rows = db.select('comments', order="timestamp DESC",
                offset=offset, limit=cnt)

        return json.dumps(list(rows))


class Stats:
    def GET(self):
        len_rows_support = db.query("SELECT COUNT(*) AS total_comments FROM comments WHERE vote=1")[0].total_comments
        len_rows_oppose = db.query("SELECT COUNT(*) AS total_comments FROM comments WHERE vote=0")[0].total_comments

        return json.dumps({
            "total": len_rows_support + len_rows_oppose,
            "support": len_rows_support,
            "oppose": len_rows_oppose
        })


class Index:
    def GET(self):
        return render.index()

if __name__ == "__main__":
    app = web.application(urls, globals())
    app.run()
