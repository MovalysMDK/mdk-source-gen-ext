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
createOrUpdate method for viewmodel of list
 -->
<xsl:template match="viewmodel[type/name='LIST_1' or type/name='LIST_2' or type/name='LIST_3' or type/name='FIXED_LIST']" mode="create-vm">
/**
 * <p>Create an empty viewmodel for list.</p>
 * 
 * @return An empty view model.
 */
- (<xsl:value-of select="implements/interface/@name"/> *) create<xsl:value-of select="implements/interface/@name"/>
<xsl:text>;&#13;</xsl:text>

/**
 * <p>Create and update a view model using a collection of <em><xsl:value-of select="./entity-to-update/name"/></em>.</p>
 * 
 * @param data A collection of <em><xsl:value-of select="./entity-to-update/name"/></em>.
 * 
 * @return The view model representation of a collection of <em><xsl:value-of select="./entity-to-update/name"/></em>.
 */
<xsl:text>- (</xsl:text>
<xsl:value-of select="./implements/interface/@name"/>
<xsl:text> *) createOrUpdate</xsl:text>
<xsl:value-of select="./implements/interface/@name"/>
<xsl:text>:(NSFetchedResultsController * )</xsl:text>
<xsl:text>data </xsl:text>
<xsl:text>;&#13;&#13;</xsl:text>

</xsl:template>


	<!-- 
	updateWithDataLoader method for viewmodel having a dataloader
	-->
	<xsl:template match="viewmodel[dataloader-impl and (type/name ='LIST_1' or type/name='FIXED_LIST')]" mode="create-vm-using-loader">

		/**
		 * <p>@brief Retreive a view model into the cache. Here, there isn't creation or update.</p>
		 * 
		 * @param dataLoader dataLoader
		 * @param context context
		 * 
		 * @return The view model representation of &lt;code&gt;p_oData&lt;/code&gt; if it exists, null otherwise.
		 */
		<xsl:text>- (</xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text>*) createOrUpdate</xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text>WithDataLoader:(</xsl:text>
		<xsl:value-of select="dataloader-impl/implements/interface/@name"/>
		<xsl:text>*)dataLoader inContext:(id&lt;MFContextProtocol&gt;)context;&#13;</xsl:text>

	</xsl:template>
	
	
	<xsl:template match="viewmodel[type/name='LIST_1' or type/name='LIST_2' or type/name='LIST_3' or type/name='FIXED_LIST']" mode="update-vm">
		<!-- normal: no update for list viewmodel -->
	</xsl:template>

</xsl:stylesheet>