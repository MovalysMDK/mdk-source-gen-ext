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

<xsl:template name="dao-getlist-interface">
	<xsl:variable name="interface" select="dao/interface"/>
	<xsl:variable name="class" select="dao/class"/>

	/**
	 * Retourne la liste de toutes les entités <xsl:value-of select="$interface/name"/>.
	 *
	 * La cascade est CascadeSet.NONE
	 *	
	 * @param p_oContext contexte transactionnel
 	 *
 	 * @return une liste d'entité <xsl:value-of select="$interface/name"/>
 	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	@Public	 
	public BOList&lt;<xsl:value-of select="$interface/name"/>&gt; getList<xsl:value-of select="$interface/name"/>
			<xsl:text>( </xsl:text>
			<xsl:text> ItfTransactionalContext p_oContext ) throws DaoException ;</xsl:text>

	/**
	 * Retourne la liste des entités <xsl:value-of select="$interface/name"/> selon la requête.
	 *
	 * La cascade est CascadeSet.NONE
	 *	
	 * @param p_oDaoQuery requête
	 * @param p_oContext contexte transactionnel
 	 *
 	 * @return une liste d'entité <xsl:value-of select="$interface/name"/>
 	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	@Public	 
	public BOList&lt;<xsl:value-of select="$interface/name"/>&gt; getList<xsl:value-of select="$interface/name"/>
			<xsl:text>( </xsl:text>
			<xsl:text>DaoQuery p_oDaoQuery, ItfTransactionalContext p_oContext ) throws DaoException ;</xsl:text>
			
	/**
	 * Retourne la liste de toutes les entités <xsl:value-of select="$interface/name"/>.
	 *
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oContext contexte transactionnel
 	 *
 	 * @return une liste d'entité <xsl:value-of select="$interface/name"/>
 	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	@Public	 
	public BOList&lt;<xsl:value-of select="$interface/name"/>&gt; getList<xsl:value-of select="$interface/name"/>
			<xsl:text>( </xsl:text>
			<xsl:text>CascadeSet p_oCascadeSet, ItfTransactionalContext p_oContext ) throws DaoException ;</xsl:text>
			
	/**
	 * Retourne la liste de toutes les entités <xsl:value-of select="$interface/name"/>.
	 *
	 * La cascade est CascadeSet.NONE
	 *	
	 * @param p_oDaoSession session Dao
	 * @param p_oContext contexte transactionnel
 	 *
 	 * @return une liste d'entité <xsl:value-of select="$interface/name"/>
 	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	@Public	 
	public BOList&lt;<xsl:value-of select="$interface/name"/>&gt; getList<xsl:value-of select="$interface/name"/>
			<xsl:text>( </xsl:text>
			<xsl:text>DaoSession p_oDaoSession, ItfTransactionalContext p_oContext ) throws DaoException ;</xsl:text>
			
	/**
	 * Retourne la liste des entités <xsl:value-of select="$interface/name"/> selon la requête.
	 *
	 * @param p_oDaoQuery requête
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oContext contexte transactionnel
 	 *
 	 * @return une liste d'entité <xsl:value-of select="$interface/name"/>
 	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	@Public	 
	public BOList&lt;<xsl:value-of select="$interface/name"/>&gt; getList<xsl:value-of select="$interface/name"/>
			<xsl:text>( </xsl:text>
			<xsl:text>DaoQuery p_oDaoQuery, CascadeSet p_oCascadeSet, ItfTransactionalContext p_oContext ) throws DaoException ;</xsl:text>
			
	/**
	 * Retourne la liste des entités <xsl:value-of select="$interface/name"/> selon la requête.
	 *
	 * La cascade est CascadeSet.NONE
	 *	
	 * @param p_oDaoQuery requête
	 * @param p_oDaoSession session Dao
	 * @param p_oContext contexte transactionnel
 	 *
 	 * @return une liste d'entité <xsl:value-of select="$interface/name"/>
 	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	@Public	 
	public BOList&lt;<xsl:value-of select="$interface/name"/>&gt; getList<xsl:value-of select="$interface/name"/>
			<xsl:text>( </xsl:text>
			<xsl:text>DaoQuery p_oDaoQuery, DaoSession p_oDaoSession, ItfTransactionalContext p_oContext ) throws DaoException ;</xsl:text>
			
	/**
	 * Retourne la liste de toutes les entités <xsl:value-of select="$interface/name"/>.
	 *
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oDaoSession session Dao
	 * @param p_oContext contexte transactionnel
 	 *
 	 * @return une liste d'entité <xsl:value-of select="$interface/name"/>
 	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	@Public	 
	public BOList&lt;<xsl:value-of select="$interface/name"/>&gt; getList<xsl:value-of select="$interface/name"/>
			<xsl:text>( </xsl:text>
			<xsl:text>CascadeSet p_oCascadeSet, DaoSession p_oDaoSession, ItfTransactionalContext p_oContext ) throws DaoException ;</xsl:text>

	/**
	 * Retourne la liste des entités <xsl:value-of select="$interface/name"/> selon la requête.
	 *
	 * @param p_oDaoQuery requête
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oDaoSession session Dao
	 * @param p_oContext contexte transactionnel
 	 *
 	 * @return une liste d'entité <xsl:value-of select="$interface/name"/>
 	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	@Public	 
	public BOList&lt;<xsl:value-of select="$interface/name"/>&gt; getList<xsl:value-of select="$interface/name"/>
			<xsl:text>( </xsl:text>
			<xsl:text>DaoQuery p_oDaoQuery, CascadeSet p_oCascadeSet, DaoSession p_oDaoSession, ItfTransactionalContext p_oContext ) throws DaoException ;</xsl:text>
</xsl:template>

<xsl:template name="dao-getlist">

	/**
	 * Retourne la liste de toutes les entités <xsl:value-of select="interface/name"/>.
	 *
	 * Les blocs par défaut sont utilisés
	 * La cascade est CascadeSet.NONE
	 *
	 * @param p_oContext contexte transactionnel
 	 *
 	 * @return une liste d'entité <xsl:value-of select="interface/name"/>
 	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public BOList&lt;<xsl:value-of select="interface/name"/>&gt; getList<xsl:value-of select="interface/name"/>
			<xsl:text>( </xsl:text>
			<xsl:text>ItfTransactionalContext p_oContext ) throws DaoException {</xsl:text>
		return this.getList<xsl:value-of select="interface/name"/>
			<xsl:text>(getSelectDaoQuery(), CascadeSet.NONE, new DaoSession(), p_oContext);</xsl:text>
	}

	/**
	 * Retourne la liste des entités <xsl:value-of select="interface/name"/> selon la requête.
	 *
	 * La cascade est CascadeSet.NONE
	 *
	 * @param p_oDaoQuery requête
	 * @param p_oContext contexte transactionnel
 	 *
 	 * @return une liste d'entité <xsl:value-of select="interface/name"/>
 	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public BOList&lt;<xsl:value-of select="interface/name"/>&gt; getList<xsl:value-of select="interface/name"/>
			<xsl:text>( </xsl:text>
			<xsl:text>DaoQuery p_oDaoQuery, ItfTransactionalContext p_oContext ) throws DaoException {</xsl:text>
		return this.getList<xsl:value-of select="interface/name"/>
			<xsl:text>( p_oDaoQuery, CascadeSet.NONE, new DaoSession(), p_oContext);</xsl:text>
	}

	/**
	 * Retourne la liste de toutes les entités <xsl:value-of select="interface/name"/>.
	 *
	 * Les blocs par défaut sont utilisés
	 *
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oContext contexte transactionnel
 	 *
 	 * @return une liste d'entité <xsl:value-of select="interface/name"/>
 	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public BOList&lt;<xsl:value-of select="interface/name"/>&gt; getList<xsl:value-of select="interface/name"/>
			<xsl:text>( </xsl:text>
			<xsl:text>CascadeSet p_oCascadeSet, ItfTransactionalContext p_oContext ) throws DaoException {</xsl:text>
		return this.getList<xsl:value-of select="interface/name"/>
			<xsl:text>( getSelectDaoQuery(), p_oCascadeSet, new DaoSession(), p_oContext );</xsl:text>
	}

	/**
	 * Retourne la liste de toutes les entités <xsl:value-of select="interface/name"/>.
	 *
	 * Les blocs par défaut sont utilisés
	 * La cascade est CascadeSet.NONE
	 *
	 * @param p_oDaoSession session Dao
	 * @param p_oContext contexte transactionnel
 	 *
 	 * @return une liste d'entité <xsl:value-of select="interface/name"/>
 	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public BOList&lt;<xsl:value-of select="interface/name"/>&gt; getList<xsl:value-of select="interface/name"/>
			<xsl:text>( </xsl:text>
			<xsl:text>DaoSession p_oDaoSession, ItfTransactionalContext p_oContext ) throws DaoException {</xsl:text>
		return this.getList<xsl:value-of select="interface/name"/>
			<xsl:text>( getSelectDaoQuery(), CascadeSet.NONE, p_oDaoSession, p_oContext );</xsl:text>
	}

	/**
	 * Retourne la liste des entités <xsl:value-of select="interface/name"/> selon la requête.
	 *
	 * @param p_oDaoQuery requête
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oContext contexte transactionnel
 	 *
 	 * @return une liste d'entité <xsl:value-of select="interface/name"/>
 	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
 	public BOList&lt;<xsl:value-of select="interface/name"/>&gt; getList<xsl:value-of select="interface/name"/>
			<xsl:text>( </xsl:text>
			<xsl:text>DaoQuery p_oDaoQuery, CascadeSet p_oCascadeSet, ItfTransactionalContext p_oContext ) throws DaoException {</xsl:text>
		return this.getList<xsl:value-of select="interface/name"/>
			<xsl:text>( p_oDaoQuery, p_oCascadeSet, new DaoSession(), p_oContext );</xsl:text>
	}

	/**
	 * Retourne la liste des entités <xsl:value-of select="interface/name"/> selon la requête.
	 *
	 * La cascade est CascadeSet.NONE
	 *
	 * @param p_oDaoQuery requête
	 * @param p_oDaoSession session Dao
	 * @param p_oContext contexte transactionnel
 	 *
 	 * @return une liste d'entité <xsl:value-of select="interface/name"/>
 	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public BOList&lt;<xsl:value-of select="interface/name"/>&gt; getList<xsl:value-of select="interface/name"/>
			<xsl:text>( </xsl:text>
			<xsl:text>DaoQuery p_oDaoQuery, DaoSession p_oDaoSession, ItfTransactionalContext p_oContext ) throws DaoException {</xsl:text>
		return this.getList<xsl:value-of select="interface/name"/>
			<xsl:text>( p_oDaoQuery, CascadeSet.NONE, p_oDaoSession, p_oContext);</xsl:text>
	}	
	
	/**
	 * Retourne la liste de toutes les entités <xsl:value-of select="interface/name"/>.
	 *
	 * Les blocs par défaut sont utilisés
	 *
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oDaoSession session Dao
	 * @param p_oContext contexte transactionnel
 	 *
 	 * @return une liste d'entité <xsl:value-of select="interface/name"/>
 	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public BOList&lt;<xsl:value-of select="interface/name"/>&gt; getList<xsl:value-of select="interface/name"/>
			<xsl:text>( </xsl:text>
			<xsl:text>CascadeSet p_oCascadeSet, DaoSession p_oDaoSession, ItfTransactionalContext p_oContext ) throws DaoException {</xsl:text>
		return this.getList<xsl:value-of select="interface/name"/>
			<xsl:text>( getSelectDaoQuery(), p_oCascadeSet, p_oDaoSession, p_oContext );</xsl:text>
	}	
	
	/**
	 * Retourne la liste des entités <xsl:value-of select="interface/name"/> selon la requête.
	 *
	 * @param p_oDaoQuery requête
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oDaoSession session Dao
	 * @param p_oContext contexte transactionnel
 	 *
 	 * @return une liste d'entité <xsl:value-of select="interface/name"/>
 	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public BOList&lt;<xsl:value-of select="interface/name"/>&gt; getList<xsl:value-of select="interface/name"/>
			<xsl:text>( </xsl:text>
			<xsl:text>DaoQuery p_oDaoQuery, CascadeSet p_oCascadeSet, DaoSession p_oDaoSession, ItfTransactionalContext p_oContext ) throws DaoException {
		</xsl:text>
		return this.getList( p_oDaoQuery, p_oCascadeSet, p_oDaoSession, p_oContext);
	}
</xsl:template>
</xsl:stylesheet>