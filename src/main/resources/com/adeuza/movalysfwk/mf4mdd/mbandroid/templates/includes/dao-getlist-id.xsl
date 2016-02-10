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

<xsl:template match="dao-interface" mode="get-list-id">
	<xsl:variable name="interface" select="dao/interface"/>
	<xsl:variable name="class" select="dao/class"/>

	<xsl:if test="count($class/implements/interface/linked-interfaces/linked-interface[name = 'IdentifiableEntity']) > 0">
	/**
	 * Retourne la liste des identifiants de toutes les entités <xsl:value-of select="$interface/name"/>.
	 * La cascade est CascadeSet.NONE
	 * @param p_oContext contexte transactionnel
	 * @return une liste d'identifiant 
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public List&lt;Long&gt; getList<xsl:value-of select="$interface/name"/><xsl:text>Id(</xsl:text>
			<xsl:text>MContext p_oContext ) throws DaoException ;</xsl:text>

	/**
	 * Retourne la liste des identifiants des entités <xsl:value-of select="$interface/name"/> selon la requête.
	 * La cascade est CascadeSet.NONE
	 * @param p_oDaoQuery requête
	 * @param p_oContext contexte transactionnel
	 * @return une liste d'identifiant 
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public List&lt;Long&gt; getList<xsl:value-of select="$interface/name"/><xsl:text>Id(</xsl:text>
			<xsl:text>DaoQuery p_oDaoQuery, MContext p_oContext ) throws DaoException ;</xsl:text>

	/**
	 * Retourne la liste des identifiants de toutes les entités <xsl:value-of select="$interface/name"/>.
	 * La cascade est CascadeSet.NONE
	 * @param p_oDaoSession session Dao
	 * @param p_oContext contexte transactionnel
	 * @return une liste d'identifiant 
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public List&lt;Long&gt; getList<xsl:value-of select="$interface/name"/><xsl:text>Id(</xsl:text>
			<xsl:text>DaoSession p_oDaoSession, MContext p_oContext ) throws DaoException ;</xsl:text>

	/**
	 * Retourne la liste des identifiants des entités <xsl:value-of select="$interface/name"/> selon la requête.
	 * La cascade est CascadeSet.NONE
	 * @param p_oDaoQuery requête
	 * @param p_oDaoSession session Dao
	 * @param p_oContext contexte transactionnel
	 * @return une liste d'identifiant 
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public List&lt;Long&gt; getList<xsl:value-of select="$interface/name"/><xsl:text>Id(</xsl:text>
			<xsl:text>DaoQuery p_oDaoQuery, DaoSession p_oDaoSession, MContext p_oContext ) throws DaoException ;</xsl:text>
	</xsl:if>
</xsl:template>

 
<xsl:template match="dao" mode="get-list-id">
	<xsl:if test="count(class/implements/interface/linked-interfaces/linked-interface[name = 'IdentifiableEntity']) > 0">
	/**
	 * Retourne la liste des identifiants de toutes les entités <xsl:value-of select="interface/name"/>.
	 * Les blocs par défaut sont utilisés
	 * La cascade est CascadeSet.NONE
	 * @param p_oContext contexte transactionnel
 	 * @return une liste d'identifiant 
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public List&lt;Long&gt; getList<xsl:value-of select="interface/name"/><xsl:text>Id(</xsl:text>
			<xsl:text>MContext p_oContext ) throws DaoException {</xsl:text>
		return this.getList<xsl:value-of select="interface/name"/><xsl:text>Id(this.getSelectIdDaoQuery(), new DaoSession(), p_oContext);</xsl:text>
	}

	/**
	 * Retourne la liste des identifiants des entités <xsl:value-of select="interface/name"/> selon la requête.
	 * La cascade est CascadeSet.NONE
	 * @param p_oDaoQuery requête
	 * @param p_oContext contexte transactionnel
 	 * @return une liste d'identifiant 
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public List&lt;Long&gt; getList<xsl:value-of select="interface/name"/><xsl:text>Id(</xsl:text>
			<xsl:text>DaoQuery p_oDaoQuery, MContext p_oContext ) throws DaoException {</xsl:text>
		return this.getList<xsl:value-of select="interface/name"/><xsl:text>Id(p_oDaoQuery, new DaoSession(), p_oContext);</xsl:text>
	}

	/**
	 * Retourne la liste des identifiants de toutes les entités <xsl:value-of select="interface/name"/>.
	 * Les blocs par défaut sont utilisés
	 * La cascade est CascadeSet.NONE
	 * @param p_oDaoSession session Dao
	 * @param p_oContext contexte transactionnel
 	 * @return une liste d'identifiant 
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public List&lt;Long&gt; getList<xsl:value-of select="interface/name"/><xsl:text>Id(</xsl:text>
			<xsl:text>DaoSession p_oDaoSession, MContext p_oContext ) throws DaoException {</xsl:text>
		return this.getList<xsl:value-of select="interface/name"/><xsl:text>Id(this.getSelectIdDaoQuery(), p_oDaoSession, p_oContext );</xsl:text>
	}

	/**
	 * Retourne la liste des identifiants des entités <xsl:value-of select="interface/name"/> selon la requête.
	 * @param p_oDaoQuery requête
	 * @param p_oDaoSession session Dao
	 * @param p_oContext contexte transactionnel
 	 * @return une liste d'identifiant 
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public List&lt;Long&gt; getList<xsl:value-of select="interface/name"/><xsl:text>Id(</xsl:text>
			<xsl:text>DaoQuery p_oDaoQuery, DaoSession p_oDaoSession, MContext p_oContext ) throws DaoException {
		return this.getListId(p_oDaoQuery,p_oDaoSession,p_oContext);
	}</xsl:text>
	</xsl:if>
</xsl:template>
</xsl:stylesheet>
