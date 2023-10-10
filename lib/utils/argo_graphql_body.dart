class ArgoGraphQLBody {
  static const lastAdded = {
    "operationName": "getChapters",
    "variables": {
      "filters": {
        "operator": "AND",
        "childExpressions": [
          {
            "operator": "AND",
            "filters": [
              {
                "op": "GE",
                "field": "Project.id",
                "relationField": "Chapter.project",
                "values": ["1"]
              }
            ]
          }
        ]
      },
      "orders": {
        "orders": [
          {"or": "DESC", "field": "Chapter.updateAt"}
        ]
      },
      "pagination": {"limit": 12, "page": 1}
    },
    "query":
        "query getChapters(\$filters: FiltersExpression!, \$orders: OrdersExpression!, \$pagination: PaginationInput) {\n  getChapters(orders: \$orders, filters: \$filters, pagination: \$pagination) {\n    chapters {\n      id\n      title\n      number\n      createAt\n      updateAt\n      project {\n        id\n        name\n        cover\n        type\n        adult\n        createAt\n        updateAt\n        __typename\n      }\n      __typename\n    }\n    count\n    currentPage\n    limit\n    totalPages\n    __typename\n  }\n}\n"
  };

  static search(String value) {
    return {
      "operationName": "latestProjects",
      "variables": {
        "filters": {
          "operator": "AND",
          "filters": [
            {
              "field": "Project.name",
              "op": "LIKE",
              "values": [value]
            }
          ]
        },
        "orders": {
          "orders": [
            {"or": "DESC", "field": "Project.updateAt"}
          ]
        },
        "pagination": {"limit": 10, "page": 1}
      },
      "query":
          "query latestProjects(\$filters: FiltersExpression!, \$orders: OrdersExpression!, \$pagination: PaginationInput) {\n  getProjects(orders: \$orders, filters: \$filters, pagination: \$pagination) {\n    projects {\n      id\n      name\n      cover\n      type\n      adult\n      createAt\n      updateAt\n      getChapters(order: {number: DESC}, skip: 0, take: 1) {\n        id\n        title\n        number\n        createAt\n        __typename\n      }\n      __typename\n    }\n    count\n    currentPage\n    limit\n    totalPages\n    __typename\n  }\n}\n"
    };
  }

  static data(int id) {
    return {
      "operationName": "project",
      "variables": {"id": id},
      "query":
          "query project(\$id: Int!) {\n  project(id: \$id) {\n    id\n    name\n    type\n    adult\n    description\n    alternative\n    authors\n    cover\n    views\n    createAt\n    updateAt\n    getChapters(order: {number: DESC}) {\n      id\n      number\n      title\n      createAt\n      __typename\n    }\n    getTags(order: {id: ASC}) {\n      id\n      name\n      __typename\n    }\n    __typename\n  }\n}\n"
    };
  }

  static content(String id) {
    return {
      "operationName": "getChapter",
      "variables": {"id": id},
      "query":
          "query getChapter(\$id: String!) {\n  getChapters(\n    orders: {orders: {or: ASC, field: \"Chapter.id\"}}\n    filters: {operator: AND, filters: [{op: EQ, field: \"Chapter.id\", values: [\$id]}], childExpressions: {operator: AND, filters: {op: GE, field: \"Project.id\", relationField: \"Chapter.project\", values: [\"1\"]}}}\n  ) {\n    chapters {\n      id\n      images\n      title\n      number\n      project {\n        id\n        name\n        cover\n        description\n        adult\n        __typename\n      }\n      __typename\n    }\n    __typename\n  }\n}\n"
    };
  }
}
