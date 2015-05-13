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

<!-- Entry point for HTML5 ViewModel Generation -->
	<xsl:output method="text"/>

	<xsl:include href="commons/import.xsl"/>
	<xsl:include href="commons/class.xsl"/>
	<xsl:include href="commons/factory/factory-body.xsl"/>
	<xsl:include href="viewmodel/factory/class-definition.xsl"/>
	<xsl:include href="viewmodel/factory/create-update-viewmodel.xsl"/>
	<xsl:include href="viewmodel/factory/define-property.xsl"/>
	<xsl:include href="viewmodel/factory/mapping.xsl"/>
	
	<xsl:include href="viewmodel/factory/method-createInstance.xsl"/>
	<xsl:include href="viewmodel/factory/method-updateViewModelWithEntity.xsl"/>
	<xsl:include href="viewmodel/factory/method-updateEntityWithViewModel.xsl"/>
	<xsl:include href="viewmodel/factory/method-updateViewModelWithDataLoader.xsl"/>
	<xsl:include href="viewmodel/factory/method-updateDataLoaderEntityWithViewModel.xsl"/>

	<xsl:template match="/">
		<xsl:apply-templates select="viewmodel" mode="declare-class"/>
	</xsl:template>

</xsl:stylesheet>