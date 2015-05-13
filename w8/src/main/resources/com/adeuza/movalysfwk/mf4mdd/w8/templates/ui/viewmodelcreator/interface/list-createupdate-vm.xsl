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
<!-- 
CreateOrUpdate method for viewmodel of list
 -->
<xsl:template match="viewmodel[type/name='LIST_1' or type/name='LIST_2' or type/name='LIST_3' or type/name='FIXED_LIST']" mode="create-vm">

<xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
<xsl:text>/// Create an empty </xsl:text><xsl:value-of select="implements/interface/@name"/><xsl:text> viewmodel for list.&#13;</xsl:text>
<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
<xsl:text>/// &lt;returns&gt;An empty </xsl:text><xsl:value-of select="implements/interface/@name"/><xsl:text> viewmodel.&lt;/returns&gt;&#13;</xsl:text>
<xsl:value-of select="implements/interface/@name"/><xsl:text> create</xsl:text><xsl:value-of select="implements/interface/@name"/><xsl:text>()</xsl:text>
<xsl:text>;&#13;</xsl:text>

<xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
<xsl:text>/// Create and update a </xsl:text><xsl:value-of select="implements/interface/@name"/><xsl:text> viewmodel using a collection of </xsl:text><xsl:value-of select="./entity-to-update/name"/><xsl:text>.&#13;</xsl:text>
<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
<xsl:text>/// &lt;param name="data"&gt; A collection of </xsl:text><xsl:value-of select="./entity-to-update/name"/><xsl:text>.&lt;/param&gt;&#13;</xsl:text>
<xsl:text>/// &lt;returns&gt;The viewmodel representation of a collection of </xsl:text><xsl:value-of select="./entity-to-update/name"/><xsl:text>.&lt;/returns&gt;&#13;</xsl:text>
<xsl:value-of select="./implements/interface/@name"/>
<xsl:text> CreateOrUpdate</xsl:text>
<xsl:value-of select="./implements/interface/@name"/>
<xsl:text>(List&lt;</xsl:text>
<xsl:value-of select="./entity-to-update/name"/>
<xsl:text>&gt; data);&#13;</xsl:text>

<xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
<xsl:text>/// Create and update a </xsl:text><xsl:value-of select="implements/interface/@name"/><xsl:text> viewmodel using a collection of </xsl:text><xsl:value-of select="./entity-to-update/name"/><xsl:text>.&#13;</xsl:text>
<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
<xsl:text>/// &lt;param name="data"&gt; A collection of </xsl:text><xsl:value-of select="./entity-to-update/name"/><xsl:text>.&lt;/param&gt;&#13;</xsl:text>
<xsl:text>/// &lt;param name="masterVm"&gt; Master viewModel.&lt;/param&gt;&#13;</xsl:text>
<xsl:text>/// &lt;returns&gt;The viewmodel representation of a collection of </xsl:text><xsl:value-of select="./entity-to-update/name"/><xsl:text>.&lt;/returns&gt;&#13;</xsl:text>
<xsl:value-of select="./implements/interface/@name"/>
<xsl:text> CreateOrUpdate</xsl:text>
<xsl:value-of select="./implements/interface/@name"/>
<xsl:text>(List&lt;</xsl:text>
<xsl:value-of select="./entity-to-update/name"/>
<xsl:text>&gt; data , IViewModel masterVm)</xsl:text>
<xsl:text>;&#13;</xsl:text>

</xsl:template>


	<!-- 
	updateWithDataLoader method for viewmodel having a dataloader
	-->
	<xsl:template match="viewmodel[dataloader-impl and (type/name ='LIST_1' or type/name='FIXED_LIST')]" mode="create-vm-using-loader">
	
		<xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
		<xsl:text>/// Retreive a viewmodel into the cache. Here, there isn't creation or update.&#13;</xsl:text>
		<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
		<xsl:text>/// &lt;param name="dataLoader"&gt; dataLoader.&lt;/param&gt;&#13;</xsl:text>
		<xsl:text>/// &lt;param name="context"&gt; context.&lt;/param&gt;&#13;</xsl:text>
		<xsl:text>/// &lt;returns&gt;The viewmodel representation of &lt;code&gt;p_oData&lt;/code&gt; if it exists, null otherwise.&lt;/returns&gt;&#13;</xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text> CreateOrUpdate</xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text>WithDataLoaderInContext(</xsl:text>
		<xsl:value-of select="dataloader-impl/implements/interface/@name"/>
		<xsl:text> dataLoader, IMFContext context);&#13;</xsl:text>

	</xsl:template>
	
	
	<xsl:template match="viewmodel[type/name='LIST_1' or type/name='LIST_2' or type/name='LIST_3' or type/name='FIXED_LIST']" mode="update-vm">
		<!-- normal: no update for list viewmodel -->
	</xsl:template>

</xsl:stylesheet>