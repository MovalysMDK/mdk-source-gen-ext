<?xml version="1.0" encoding="UTF-8"?>
<!--

    Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com)

    This file is part of Movalys MDK.
    Movalys MDK is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    Movalys MDK is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU Lesser General Public License for more details.
    You should have received a copy of the GNU Lesser General Public License
    along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


    <xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/ui/viewmodelcreator/external-list.xsl" />
    <xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/ui/viewmodelcreator/compute-update-method.xsl" />

    <!-- 
Update method for viewmodel : data parameter
 -->
    <xsl:template match="viewmodel[type/name='MASTER']" mode="update-vm">
        <xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
        <xsl:text>/// Update a </xsl:text><xsl:value-of select="implements/interface/@name"/><xsl:text> viewmodel </xsl:text><xsl:if test="entity-to-update"><xsl:text> using a </xsl:text><xsl:value-of select="entity-to-update/name"/></xsl:if><xsl:text>.&#13;</xsl:text>
        <xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
        <xsl:if test="entity-to-update"><xsl:text>/// &lt;param name="data"&gt; An instance of </xsl:text><xsl:value-of select="entity-to-update/name"/><xsl:text>.&lt;/param&gt;&#13;</xsl:text></xsl:if>
        <xsl:text>/// &lt;returns&gt;The viewmodel representation</xsl:text><xsl:if test="entity-to-update"><xsl:text> of an </xsl:text><xsl:value-of select="entity-to-update/name"/><xsl:text> instance</xsl:text></xsl:if><xsl:text>.&lt;/returns&gt;&#13;</xsl:text>
        <xsl:value-of select="implements/interface/@name"/><xsl:text> </xsl:text>
        <xsl:apply-templates select="." mode="compute-update-method-name"/>
        <xsl:text>(</xsl:text>
        <xsl:apply-templates select="." mode="compute-update-method-parameter-declaration"/>
        <xsl:text> );&#13;</xsl:text>
    </xsl:template>

    <!-- For pickerlist in fixedList -->
    <xsl:template match="viewmodel[type/name='FIXED_LIST']" mode="update-vm">
        <xsl:for-each select="external-lists/external-list/viewmodel[type/name='LIST_1__ONE_SELECTED']">
            <xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
            <xsl:text>/// Update a viewmodel </xsl:text><xsl:if test="./external-lists/external-list/viewmodel/type/item"><xsl:text> using a </xsl:text><xsl:value-of select="./external-lists/external-list/viewmodel/type/item"/></xsl:if><xsl:text>.&#13;</xsl:text>
            <xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
            <xsl:if test="./external-lists/external-list/viewmodel/type/item"><xsl:text>/// &lt;param name="data"&gt; An instance of </xsl:text><xsl:value-of select="./external-lists/external-list/viewmodel/type/item"/><xsl:text>.&lt;/param&gt;&#13;</xsl:text></xsl:if>
            <xsl:text>/// &lt;returns&gt;The viewmodel representation</xsl:text><xsl:if test="./external-lists/external-list/viewmodel/type/item"><xsl:text> of an </xsl:text><xsl:value-of select="./external-lists/external-list/viewmodel/type/item"/><xsl:text> instance</xsl:text></xsl:if><xsl:text>.&lt;/returns&gt;&#13;</xsl:text>
            <xsl:value-of select="./type/item"/><xsl:text> update</xsl:text><xsl:value-of select="./type/item"/><xsl:text>(</xsl:text>
            <xsl:value-of select="./entity-to-update/name"/>
            <xsl:text> data);&#13;</xsl:text>

            <xsl:apply-templates select="self::node()[dataloader-impl]" mode="update-vm-using-loader"/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="update-vm">
        <xsl:if test="not(parent-viewmodel[@type='FIXED_LIST'])">
            <xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
            <xsl:text>/// Update a </xsl:text><xsl:value-of select="implements/interface/@name"/><xsl:text> viewmodel </xsl:text><xsl:if test="entity-to-update"><xsl:text> using a </xsl:text><xsl:value-of select="entity-to-update/name"/></xsl:if><xsl:text>.&#13;</xsl:text>
            <xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
            <xsl:if test="entity-to-update"><xsl:text>/// &lt;param name="data"&gt; An instance of </xsl:text><xsl:value-of select="entity-to-update/name"/><xsl:text>.&lt;/param&gt;&#13;</xsl:text></xsl:if>
            <xsl:text>/// &lt;returns&gt;The viewmodel representation</xsl:text><xsl:if test="entity-to-update"><xsl:text> of an </xsl:text><xsl:value-of select="entity-to-update/name"/><xsl:text> instance</xsl:text></xsl:if><xsl:text>.&lt;/returns&gt;&#13;</xsl:text>
            <xsl:value-of select="type/item"/><xsl:text> </xsl:text>
            <xsl:apply-templates select="." mode="compute-update-method-name"/>
            <xsl:text>(</xsl:text>
            <xsl:apply-templates select="." mode="compute-update-method-parameter-declaration"/>
            <xsl:text> );&#13;</xsl:text>

            <xsl:apply-templates select="self::node()[dataloader-impl]" mode="update-vm-using-loader"/>
        </xsl:if>
    </xsl:template>


    <xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="add-picker-list-to-content-update">
        <xsl:value-of select="implements/interface/@name"/>
        <xsl:text> list</xsl:text>
        <xsl:value-of select="uml-name"/>
        <xsl:text> = ClassLoader.GetInstance().GetBean&lt;</xsl:text>
        <xsl:value-of select="implements/interface/@name"/>
        <xsl:text>&gt;();&#13;</xsl:text>
        <xsl:text>list</xsl:text>
        <xsl:value-of select="uml-name"/>
        <xsl:text>.Clear(); &#13; &#13;</xsl:text>
        <xsl:text>if (p_oLst</xsl:text>
        <xsl:value-of select="uml-name"/>
        <xsl:text> != null) {&#13;foreach (</xsl:text>
        <xsl:value-of select="entity-to-update/name"/>
        <xsl:text> o</xsl:text>
        <xsl:value-of select="entity-to-update/name"/>
        <xsl:text> in p_oLst</xsl:text>
        <xsl:value-of select="uml-name"/>
        <xsl:text>) {&#13;list</xsl:text>
        <xsl:value-of select="uml-name"/>
        <xsl:text>.ListViewModel.Add(this.update</xsl:text>
        <xsl:value-of select="type/item"/>
        <xsl:text>(o</xsl:text>
        <xsl:value-of select="entity-to-update/name"/>
        <xsl:text>));&#13;}&#13;}&#13;r_oMasterViewModel.Lst</xsl:text>
        <xsl:value-of select="implements/interface/@name"/>
        <xsl:text> = list</xsl:text>
        <xsl:value-of select="uml-name"/>
        <xsl:text>;&#13;&#13;</xsl:text>
    </xsl:template>


    <xsl:template match="viewmodel[dataloader-impl and type/name ='MASTER']" mode="update-vm-using-loader">
        <xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
        <xsl:text>/// Retreive a </xsl:text><xsl:value-of select="implements/interface/@name"/><xsl:text> viewmodel into the cache. Here, there isn't creation or update.&#13;</xsl:text>
        <xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
        <xsl:text>/// &lt;param name="dataLoader"&gt; dataLoader.&#13;</xsl:text>
        <xsl:text>/// &lt;returns&gt;The viewmodel representation of &lt;code&gt;p_oData&lt;/code&gt; if it exists, null otherwise.&lt;/returns&gt;&#13;</xsl:text>
        <xsl:value-of select="implements/interface/@name"/>
        <xsl:text> update</xsl:text>
        <xsl:value-of select="implements/interface/@name"/>
        <xsl:text>WithDataLoaderInContext(</xsl:text>
        <xsl:value-of select="dataloader-impl/implements/interface/@name"/>
        <xsl:text> dataLoader, IMFContext context </xsl:text>
        <xsl:text>);&#13;</xsl:text>
    </xsl:template>

    <xsl:template match="viewmodel[type/name='LISTITEM_1' or type/name='LISTITEM_2' or type/name='LISTITEM_3' or type/name='FIXED_LIST_ITEM']" mode="update-vm">
        <!-- normal: no update for list item viewmodel -->
    </xsl:template>

    <xsl:template match="viewmodel[type/name='LIST_1' or type/name='LIST_2' or type/name='LIST_3']" mode="update-vm">
        <!-- normal: no update for list viewmodel -->
    </xsl:template>

</xsl:stylesheet>