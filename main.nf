process getPrimateTree {
    output:
    path "ref.nw.gz"

    script:
    """
    wget -q https://booster.pasteur.fr/static/files/primates/ref.nw.gz
    """
}

process extractTips {
    publishDir "results", mode: 'copy'

    input:
    path nw_tree

    output:
    path "tree_tips.txt"

    script:
    """
    gotree stats tips -i ${nw_tree} > tree_tips.txt
    """
}

workflow {
    tree_ch = getPrimateTree()
    tips_ch = extractTips(tree_ch)

    tips_ch
        .splitCsv(sep: '\t', header: true)
        .count()
        .view { count -> "L'arbre a ${count} tips." }
}
